return {
  black = 0xff181926,
  white = 0xffcad3f5,
  red = 0xffed8796,
  green = 0xffa6da95,
  blue = 0xff8aadf4,
  yellow = 0xffeed49f,
  orange = 0xfff5a97f,
  magenta = 0xffc6a0f6,
  grey = 0xff939ab7,
  teal = 0xff8bd5ca,
  sky = 0xff91d7e3,
  pink = 0xfff5bde6,
  transparent = 0x00000000,

  bar = {
    bg = 0xff24273a,
    border = 0xff2c2e34,
  },
  popup = {
    bg = 0xff282828,
    border = 0xff7f8490,
    card = 0xff232634,
  },
  spaces = {
    active = 0xff414559,
    inactive = 0xff303446
  },
  bg1 = 0xff1B2128,
  bg2 = 0xff414559,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
