# Swanston

![A sample rendering of the Swanston typeface in normal and bold weights, showing ASCII](/assets/swanston.png)

Swanston is a retro-inspired outline typeface designed to resemble bitmap fonts of times past while still being scalable to higher DPI monitors. Nearly all of the [WGL4](https://en.wikipedia.org/wiki/Windows_Glyph_List_4) set of glyphs is supported, including Latin, Greek, Cyrillic, and codepage 437 box-drawing and symbols. Both regular and bold weights are provided. Designed for use in terminals, all glyphs are 8x16, so Swanston can fit where raster fonts were formerly used.

### Usage

- Swanston is designed for and looks best at 16 pixel size or multiples thereof. On standard DPI Windows, this is 12pt. For other platforms, it is 16pt. Sizes smaller than 16 pixels will have compromised legibility. Larger non-multiple-of-16 sizes work fine, but might not be as clear.
- While Swanston resembles bitmap fonts, the font is intended to be seen anti-aliased. Bilevel rendering will look acceptable in the normal weight, but will _not_ be legible in the bold weight.
- The bold weight is intended to support terminals and IDEs that expect that weight to exist. Usage as the primary weight is not recommended since some legibility is compromised to keep metrics as similar as possible. 

### Notes

Swanston is licenced under the SIL OFL, so freely use it for whatever you want.

Combining marks are defined but might not work as expected. Use the precomposed Unicode characters.

Some font renderers might have trouble with Swanston. I'll try to fix things as they come up.