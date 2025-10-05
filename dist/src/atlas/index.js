import Path from 'node:path';
import { Atlas } from './atlas.js';
import { saveAtlasImage, saveJsonData, saveTilesetImage } from './save.js';
import { Tileset } from './tileset.js';
/**
 * Packs atlases based on the provided configuration file.
 * @param configPath The path to the TOML configuration file.
 */
export function packAtlas(config) {
    // Validate the configuration.
    if ((!config.atlases || config.atlases.length === 0) && (!config.tilesets || config.tilesets.length === 0)) {
        process.stdout.write('No atlases or tilesets in config file.\n');
        return;
    }
    if (config.atlases) {
        packAtlases(config);
    }
    if (config.tilesets) {
        padTilesets(config);
    }
}
function packAtlases(config) {
    if (!config.atlases) {
        return;
    }
    // Process each atlas configuration.
    let packedCount = 0;
    for (const atlasConfig of config.atlases) {
        // Convert numeric properties to numbers.
        if (atlasConfig.extrude) {
            atlasConfig.extrude = Number(atlasConfig.extrude);
        }
        if (atlasConfig.maxWidth) {
            atlasConfig.maxWidth = Number(atlasConfig.maxWidth);
        }
        if (atlasConfig.maxHeight) {
            atlasConfig.maxHeight = Number(atlasConfig.maxHeight);
        }
        const atlas = new Atlas(atlasConfig);
        if (!atlas.pack()) {
            process.stdout.write(`Error: Unable to pack atlas "${atlasConfig.name}".\n`);
            continue;
        }
        // Create the save folder if it does not exist.
        const saveFolder = Path.join(process.cwd(), atlasConfig.saveFolder);
        // Save the atlas image.
        try {
            saveAtlasImage(atlasConfig.name, saveFolder, atlas);
        }
        catch (error) {
            process.stdout.write(`Error: Failed to save atlas image for "${atlasConfig.name}": ${error.message}\n`);
            continue;
        }
        // Save the JSON data if required.
        if (!atlasConfig.noData) {
            try {
                saveJsonData(atlasConfig.name, saveFolder, atlas);
            }
            catch (error) {
                process.stdout.write(`Error: Failed to save JSON data for "${atlasConfig.name}": ${error.message}\n`);
                continue;
            }
        }
        packedCount++;
        process.stdout.write(`Successfully packed atlas "${atlasConfig.name}".\n`);
    }
    // Provide feedback on the packing process.
    if (packedCount === 0) {
        process.stdout.write('No atlases were successfully packed.\n');
    }
    else {
        process.stdout.write(`Successfully packed ${packedCount} atlas(es).\n`);
    }
}
function padTilesets(config) {
    if (!config.tilesets) {
        return;
    }
    let paddedCount = 0;
    for (const tilesetConfig of config.tilesets) {
        // Convert numeric properties to numbers.
        if (tilesetConfig.tileWidth) {
            tilesetConfig.tileWidth = Number(tilesetConfig.tileWidth);
        }
        if (tilesetConfig.tileHeight) {
            tilesetConfig.tileHeight = Number(tilesetConfig.tileHeight);
        }
        if (!tilesetConfig.tileWidth || !tilesetConfig.tileHeight) {
            process.stdout.write(`Error: tileWidth and tileHeight must be specified for tileset "${tilesetConfig.name}".\n`);
            continue;
        }
        if (tilesetConfig.extrude) {
            tilesetConfig.extrude = Number(tilesetConfig.extrude);
        }
        paddedCount++;
        const tileset = new Tileset(tilesetConfig);
        const saveFolder = Path.join(process.cwd(), tilesetConfig.saveFolder);
        try {
            saveTilesetImage(tilesetConfig.name, saveFolder, tileset);
        }
        catch (error) {
            process.stdout.write(`Error: Failed to save atlas image for "${tilesetConfig.name}": ${error.message}\n`);
        }
    }
    if (paddedCount === 0) {
        process.stdout.write('No tilesets were successfully padded.\n');
    }
    else {
        process.stdout.write(`Successfully padded ${paddedCount} tileset(s).\n`);
    }
}
