import { existsSync, lstatSync, readdirSync } from 'node:fs';
import path from 'node:path';
import { PNG } from 'pngjs';
import { AtlasPacker } from './atlasPacker.js';
import { Image } from './image.js';
import { Rectangle } from './rectangle.js';
/**
 * The sprite atlas class holds the image and position data of the individual sprites.
 */
export class Atlas {
    /**
     * The final packed image.
     */
    packedImage;
    /**
     * The final packed image positions inside the atlas.
     */
    packedRects = [];
    /**
     * The images that are in the atlas.
     */
    images = new Map();
    /**
     * The start rectangles.
     */
    rects = [];
    /**
     * The file paths to the images.
     */
    imagePaths = [];
    /**
     * The atlas configuration.
     */
    config;
    /**
     * Indicates whether an error was found during initialization.
     * If true, the atlas cannot be packed.
     */
    errorFound = false;
    /**
     * Creates a new atlas instance.
     * @param config The configuration object for the atlas.
     */
    constructor(config) {
        this.config = config;
        // Validate the configuration.
        if (!this.validateConfig()) {
            this.errorFound = true;
            process.stdout.write('Error: Invalid config.\n');
            return;
        }
        // Get all the PNG images from the folders in the config. This is not recursive.
        if (config.folders) {
            for (const folder of config.folders) {
                const fullPath = path.join(process.cwd(), folder);
                if (existsSync(fullPath) && lstatSync(fullPath).isDirectory()) {
                    const paths = this.getAllImagesPathsFromFolder(fullPath);
                    this.imagePaths = this.imagePaths.concat(paths);
                }
                else {
                    process.stdout.write(`Error: folder "${fullPath}" does not exist.\n`);
                }
            }
        }
        // Get all the PNG images from the files in the config.
        if (config.files) {
            for (const file of config.files) {
                const fullPath = path.join(process.cwd(), file);
                const imagePath = this.getFullImagePath(fullPath);
                if (imagePath) {
                    this.imagePaths.push(imagePath);
                }
            }
        }
        if (this.imagePaths.length === 0) {
            this.errorFound = true;
            process.stdout.write('No images to pack.\n');
            return;
        }
        let duplicates = false;
        const names = [];
        for (const path of this.imagePaths) {
            const name = config.folderInName ? `${path.folderName}_${path.fileName}` : path.fileName;
            // Check for duplicates.
            if (names.includes(name)) {
                duplicates = true;
                process.stdout.write(`Error: Duplicate name "${name}" found. Cannot have duplicate names.\n`);
                continue;
            }
            names.push(name);
            // Load the image and create the rectangle.
            const image = Image.fromFile(path.fullPath, config.trimmed ?? true, config.extrude ?? 0);
            this.images.set(name, image);
            this.rects.push(new Rectangle(0, 0, image.width, image.height, name));
        }
        if (duplicates) {
            process.stdout.write('Error: Duplicate image names found. Try using the "folderInName" config option.\n');
            this.errorFound = true;
        }
    }
    /**
     * Packs all the images into one image.
     * @returns True if the packing was successful.
     */
    pack() {
        if (this.errorFound) {
            return false;
        }
        // Perform the actual packing.
        const packer = new AtlasPacker(this.rects, this.config.packMethod ?? 'optimal', this.config.maxWidth ?? 4096, this.config.maxHeight ?? 4096);
        if (!packer.pack()) {
            return false;
        }
        if (!packer.smallestBounds) {
            return false;
        }
        // Create the final blank image with the correct size.
        this.packedImage = new Image(packer.smallestBounds.width, packer.smallestBounds.height);
        // Add all images into the final image.
        for (const rect of packer.smallestLayout) {
            const img = this.images.get(rect.name);
            if (img) {
                PNG.bitblt(img.pngData, this.packedImage.pngData, 0, 0, img.width, img.height, rect.x, rect.y);
            }
        }
        this.packedRects = packer.smallestLayout;
        process.stdout.write(`Atlas "${this.config.name}" has been packed successfully.\n`);
        return true;
    }
    /**
     * Loops through a folder and gets all PNG file paths. This is not recursive.
     * @param imagePath The folder path to search for PNG files.
     * @returns A list of image paths.
     */
    getAllImagesPathsFromFolder(imagePath) {
        const imagePaths = [];
        for (const file of readdirSync(imagePath)) {
            const fullPath = path.join(imagePath, file);
            if (lstatSync(fullPath).isFile()) {
                const imagePath = this.getFullImagePath(fullPath);
                if (imagePath) {
                    imagePaths.push(imagePath);
                }
            }
        }
        return imagePaths;
    }
    /**
     * Creates a path with the direct parent folder name and file name for easy use later.
     * @param imagePath The full path to the image file.
     * @returns The created ImagePath object, or null if the file is not a PNG.
     */
    getFullImagePath(imagePath) {
        if (path.extname(imagePath) === '.png') {
            const folders = path.dirname(imagePath).split(path.sep);
            const folder = folders[folders.length - 1];
            return {
                fullPath: imagePath,
                folderName: folder,
                fileName: path.basename(imagePath, path.extname(imagePath)),
            };
        }
        process.stdout.write(`Warning: "${imagePath}" is not a PNG image.\n`);
        return null;
    }
    /**
     * Validates the configuration object.
     * @returns True if the configuration is valid, false otherwise.
     */
    validateConfig() {
        if (!this.config.name) {
            process.stdout.write('Error: Config must have a name.\n');
            return false;
        }
        return true;
    }
}
