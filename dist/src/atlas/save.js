import { existsSync, mkdirSync, writeFileSync } from 'node:fs';
import Path from 'node:path';
import { PNG } from 'pngjs';
/**
 * Saves the atlas image to a PNG file.
 * @param name The name of the file (without extension).
 * @param saveFolder The folder where the file will be saved.
 * @param atlas The created atlas containing the packed image.
 * @throws Will throw an error if the atlas image is undefined.
 */
export function saveAtlasImage(name, saveFolder, atlas) {
    // Ensure the save folder exists.
    if (!existsSync(saveFolder)) {
        mkdirSync(saveFolder, { recursive: true });
    }
    const path = Path.join(saveFolder, `${name}.png`);
    if (atlas.packedImage) {
        try {
            const buffer = PNG.sync.write(atlas.packedImage.pngData, {
                colorType: 6,
            });
            writeFileSync(path, buffer);
            process.stdout.write(`Atlas image saved to: ${path}\n`);
        }
        catch (error) {
            throw new Error(`Failed to save atlas image: ${error.message}`);
        }
    }
    else {
        throw new Error('Atlas image is undefined. Cannot save.');
    }
}
export function saveTilesetImage(name, saveFolder, tileset) {
    // Ensure the save folder exists.
    if (!existsSync(saveFolder)) {
        mkdirSync(saveFolder, { recursive: true });
    }
    const path = Path.join(saveFolder, `${name}.png`);
    if (tileset.image) {
        try {
            const buffer = PNG.sync.write(tileset.image.pngData, {
                colorType: 6,
            });
            writeFileSync(path, buffer);
            process.stdout.write(`Tileset image saved to: ${path}\n`);
        }
        catch (error) {
            throw new Error(`Failed to save tileset image: ${error.message}`);
        }
    }
    else {
        throw new Error('Tileset image is undefined. Cannot save.');
    }
}
/**
 * Saves the Lua data to a file.
 * @param name The name of the file (without extension).
 * @param saveFolder The folder where the file will be saved.
 * @param atlas The created atlas containing the packed rectangles and image data.
 * @throws Will throw an error if writing fails.
 */
export function saveLuaData(name, saveFolder, atlas) {
    // Ensure the save folder exists.
    if (!existsSync(saveFolder)) {
        mkdirSync(saveFolder, { recursive: true });
    }
    let content = 'local FrameData = {}\n\n';
    content += 'FrameData.frames = {\n';
    for (const rect of atlas.packedRects) {
        const image = atlas.images.get(rect.name);
        if (!image) {
            continue;
        }
        content += `  {\n`;
        content += `    filename = '${rect.name}',\n`;
        content += `    rect = {\n`;
        content += `      x = ${rect.x + Number(image.extrude)},\n`;
        content += `      y = ${rect.y + Number(image.extrude)},\n`;
        content += `      width = ${rect.width - Number(image.extrude) * 2},\n`;
        content += `      height = ${rect.height - Number(image.extrude) * 2},\n`;
        content += `    },\n`;
        content += `    trimmed = ${image.trimmed},\n`;
        content += `    sourceSize = {\n`;
        content += `      x = ${image.sourceX},\n`;
        content += `      y = ${image.sourceY},\n`;
        content += `      width = ${image.sourceWidth},\n`;
        content += `      height = ${image.sourceHeight},\n`;
        content += `    },\n`;
        content += `  },\n`;
    }
    content += '}\n\n';
    content += 'FrameData.meta = {\n';
    content += `  image = '${name}.png',\n`;
    content += `  size = {\n`;
    content += `    width = ${atlas.packedImage?.width || 0},\n`;
    content += `    height = ${atlas.packedImage?.height || 0},\n`;
    content += `  },\n`;
    content += `}\n\n`;
    content += 'return FrameData\n';
    const path = Path.join(saveFolder, `${name}.lua`);
    try {
        writeFileSync(path, content);
        process.stdout.write(`JSON data saved to: ${path}\n`);
    }
    catch (error) {
        throw new Error(`Failed to save JSON data: ${error.message}`);
    }
}
