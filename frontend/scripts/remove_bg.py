#!/usr/bin/env python3

from __future__ import annotations

import argparse
import shutil
from collections import Counter, deque
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

from PIL import Image


Color = tuple[int, int, int]


@dataclass
class DetectionResult:
    status: str
    colors: tuple[Color, ...] = ()
    tolerance: int = 12


def color_distance(a: Color, b: Color) -> int:
    return max(abs(a[0] - b[0]), abs(a[1] - b[1]), abs(a[2] - b[2]))


def is_grayish(color: Color, spread: int = 24) -> bool:
    return max(color) - min(color) <= spread


def cluster_colors(colors: Iterable[Color], tolerance: int) -> list[tuple[Color, int]]:
    groups: list[list[int]] = []
    counts: list[int] = []

    for color in colors:
        matched = False
        for index, group in enumerate(groups):
            center = (group[0], group[1], group[2])
            if color_distance(color, center) <= tolerance:
                count = counts[index]
                groups[index] = [
                    int((group[0] * count + color[0]) / (count + 1)),
                    int((group[1] * count + color[1]) / (count + 1)),
                    int((group[2] * count + color[2]) / (count + 1)),
                ]
                counts[index] += 1
                matched = True
                break
        if not matched:
            groups.append([color[0], color[1], color[2]])
            counts.append(1)

    combined = [((group[0], group[1], group[2]), counts[index]) for index, group in enumerate(groups)]
    combined.sort(key=lambda item: item[1], reverse=True)
    return combined


def border_samples(image: Image.Image, inset: int = 0, step: int = 4) -> list[Color]:
    width, height = image.size
    pixels = image.load()
    samples: list[Color] = []

    for x in range(inset, width - inset, step):
        samples.append(pixels[x, inset][:3])
        samples.append(pixels[x, height - 1 - inset][:3])
    for y in range(inset, height - inset, step):
        samples.append(pixels[inset, y][:3])
        samples.append(pixels[width - 1 - inset, y][:3])
    return samples


def detect_background(image: Image.Image) -> DetectionResult:
    if "A" in image.getbands():
        alpha = image.getchannel("A")
        if alpha.getextrema()[0] < 255:
            return DetectionResult("already_transparent")

    rgba = image.convert("RGBA")
    width, height = rgba.size
    pixels = rgba.load()
    corners = [
        pixels[0, 0][:3],
        pixels[width - 1, 0][:3],
        pixels[0, height - 1][:3],
        pixels[width - 1, height - 1][:3],
    ]

    if max(color_distance(corners[0], corner) for corner in corners[1:]) <= 14:
        return DetectionResult("solid", (corners[0],), 14)

    samples = border_samples(rgba, inset=0) + border_samples(rgba, inset=min(width, height) // 32)
    clusters = cluster_colors(samples, 10)
    if len(clusters) >= 2:
        first, second = clusters[0], clusters[1]
        coverage = first[1] + second[1]
        dominant_ratio = coverage / max(1, len(samples))
        if (
            dominant_ratio >= 0.7
            and abs(first[1] - second[1]) / max(first[1], second[1]) <= 0.45
            and is_grayish(first[0])
            and is_grayish(second[0])
            and color_distance(first[0], second[0]) >= 18
        ):
            return DetectionResult("checkerboard", (first[0], second[0]), 14)

    corner_clusters = cluster_colors(corners, 12)
    if len(corner_clusters) >= 2 and corner_clusters[0][1] + corner_clusters[1][1] == 4:
        return DetectionResult("checkerboard", (corner_clusters[0][0], corner_clusters[1][0]), 14)

    return DetectionResult("unknown")


def flood_fill_mask(image: Image.Image, allowed_colors: tuple[Color, ...], tolerance: int) -> set[tuple[int, int]]:
    rgba = image.convert("RGBA")
    width, height = rgba.size
    pixels = rgba.load()
    queue = deque(
        [
            (0, 0),
            (width - 1, 0),
            (0, height - 1),
            (width - 1, height - 1),
        ]
    )
    visited: set[tuple[int, int]] = set()

    while queue:
        x, y = queue.popleft()
        if (x, y) in visited or x < 0 or y < 0 or x >= width or y >= height:
            continue

        color = pixels[x, y][:3]
        if not any(color_distance(color, allowed) <= tolerance for allowed in allowed_colors):
            continue

        visited.add((x, y))
        queue.extend(((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)))

    return visited


def apply_transparency(image: Image.Image, mask: set[tuple[int, int]]) -> Image.Image:
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    for x, y in mask:
        pixels[x, y] = (pixels[x, y][0], pixels[x, y][1], pixels[x, y][2], 0)
    return rgba


def process_file(source: Path, target_dir: Path) -> str:
    image = Image.open(source)
    target_dir.mkdir(parents=True, exist_ok=True)
    output = target_dir / source.name
    detection = detect_background(image)

    if detection.status == "already_transparent":
        image.convert("RGBA").save(output)
        return detection.status

    if detection.status in {"solid", "checkerboard"}:
        mask = flood_fill_mask(image, detection.colors, detection.tolerance)
        if mask:
            apply_transparency(image, mask).save(output)
            return detection.status

    shutil.copy2(source, output)
    return "unknown"


def main() -> int:
    parser = argparse.ArgumentParser(description="Remove solid or checkerboard backgrounds from PNG assets.")
    parser.add_argument("input_dir", nargs="?", default="frontend/assets/icons")
    parser.add_argument("output_dir", nargs="?", default="frontend/assets/icons/transparent")
    args = parser.parse_args()

    input_dir = Path(args.input_dir)
    output_dir = Path(args.output_dir)

    if not input_dir.exists():
        raise SystemExit(f"Input directory does not exist: {input_dir}")

    results: list[tuple[str, str]] = []
    for source in sorted(input_dir.glob("*.png")):
        status = process_file(source, output_dir)
        results.append((source.name, status))

    for name, status in results:
        line = f"{name} -> {status}"
        if status == "unknown":
            line += " (warning: left unchanged for manual review)"
        print(line)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
