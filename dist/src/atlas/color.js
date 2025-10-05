/**
 * RGBA color class to make working with pixels easier.
 */
export class Color {
    /**
     * The red channel (0-255).
     */
    red;
    /**
     * The green channel (0-255).
     */
    green;
    /**
     * The blue channel (0-255).
     */
    blue;
    /**
     * The alpha channel (0-255).
     */
    alpha;
    /**
     * Creates a new color instance.
     * @param red The red channel value [0-255].
     * @param green The green channel value [0-255].
     * @param blue The blue channel value [0-255].
     * @param alpha The alpha channel value [0-255].
     */
    constructor(red, green, blue, alpha) {
        this.red = Math.floor(red);
        this.green = Math.floor(green);
        this.blue = Math.floor(blue);
        this.alpha = Math.floor(alpha);
    }
    /**
     * Compares this color with another color.
     * @param other The other color to compare.
     * @returns True if the colors are identical.
     */
    equals(other) {
        return (this.red === other.red && this.green === other.green && this.blue === other.blue && this.alpha === other.alpha);
    }
}
