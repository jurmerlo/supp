import { beforeEach, describe, expect, it } from 'vitest';

import type { AtlasConfig } from '../config/atlasConfig.js';
import { Atlas } from './atlas.js';
import { AtlasPacker } from './atlasPacker.js';

describe('Packer', () => {
  let config: AtlasConfig;
  let atlas: Atlas;

  beforeEach(() => {
    config = {
      name: 'test',
      outDir: 'out',
      folders: ['./testFiles/atlas'],
      extrude: 0,
      trimmed: true,
    };
    atlas = new Atlas(config);
  });

  it('Should pack the rectangles in basic mode.', () => {
    const packer = new AtlasPacker(atlas.rects, 'basic', 4096, 4096);
    const success = packer.pack();

    expect(success).toBe(true);
    expect(packer.smallestBounds?.width).toBe(282);
    expect(packer.smallestBounds?.height).toBe(72);
  });

  it('Should pack the rectangles in optimal mode.', () => {
    const packer = new AtlasPacker(atlas.rects, 'optimal', 4096, 4096);
    const success = packer.pack();

    expect(success).toBe(true);
    expect(packer.smallestBounds?.width).toBe(126);
    expect(packer.smallestBounds?.height).toBe(120);
  });

  it('Should pack the rectangles using a max width.', () => {
    const packer = new AtlasPacker(atlas.rects, 'optimal', 100, 4096);
    const success = packer.pack();

    expect(success).toBe(true);
    expect(packer.smallestBounds?.width).toBe(90);
    expect(packer.smallestBounds?.height).toBe(172);
  });

  it('Should pack the rectangles using a max height.', () => {
    const packer = new AtlasPacker(atlas.rects, 'optimal', 4096, 100);
    const success = packer.pack();

    expect(success).toBe(true);
    expect(packer.smallestBounds?.width).toBe(234);
    expect(packer.smallestBounds?.height).toBe(72);
  });

  it("Should not pack the rectangles if they don't fit", () => {
    const packer = new AtlasPacker(atlas.rects, 'optimal', 90, 90);
    const success = packer.pack();

    expect(success).toBe(false);
  });
});
