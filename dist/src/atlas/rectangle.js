/**
 * Represents a rectangle used for packing calculations.
 */
export class Rectangle {
    /**
     * The filename of the image this rectangle belongs to.
     */
    name;
    /**
     * The x position of the rectangle in pixels.
     */
    x;
    /**
     * The y position of the rectangle in pixels.
     */
    y;
    /**
     * The width of the rectangle in pixels.
     */
    width;
    /**
     * The height of the rectangle in pixels.
     */
    height;
    /**
     * Creates a new rectangle instance.
     * @param x The x position of the rectangle in pixels.
     * @param y The y position of the rectangle in pixels.
     * @param width The width of the rectangle in pixels.
     * @param height The height of the rectangle in pixels.
     * @param name Optional filename to identify the rectangle.
     */
    // biome-ignore lint/nursery/useMaxParams: Using more parameters for performance.
    constructor(x, y, width, height, name = '') {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.name = name;
    }
    /**
     * Creates a new instance with the same values as this rectangle.
     * @returns A new rectangle instance.
     */
    clone() {
        return new Rectangle(this.x, this.y, this.width, this.height, this.name);
    }
    /**
     * Calculates the area of this rectangle.
     * @returns The area of the rectangle in pixels.
     */
    area() {
        return this.width * this.height;
    }
}
