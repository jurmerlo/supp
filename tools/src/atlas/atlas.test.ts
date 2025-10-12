import { beforeAll, describe, expect, it } from 'vitest';

import type { AtlasConfig } from '../config/atlasConfig.js';
import { Atlas } from './atlas.js';

describe('Atlas', () => {
  let config: AtlasConfig;

  beforeAll(() => {
    config = {
      name: 'test',
      outDir: 'out',
      folders: ['./testFiles/atlas'],
      trimmed: true,
      extrude: 1,
    };
  });

  it('Should pack an atlas.', () => {
    console.log('Running atlas tests...');
    const atlas = new Atlas(config);
    const success = atlas.pack();

    expect(success).toBe(true);
    expect(atlas.packedImage?.width).toBe(132);
    expect(atlas.packedImage?.height).toBe(126);
  });

  it('Should add folder names to the file names.', () => {
    config.folderInName = true;

    const atlas = new Atlas(config);
    const success = atlas.pack();

    expect(success).toBe(true);
    for (const rect of atlas.packedRects) {
      expect(rect.name.startsWith('atlas_')).toBe(true);
    }
  });
});
