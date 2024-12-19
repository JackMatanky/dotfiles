return {
  black = 0xff181819,
  white = 0xffe2e2e3,
  red = 0xfff38ba8,
  green = 0xffa6e3a1,
  blue = 0xff8fa9e6,
  yellow = 0xfff9e2af,
  orange = 0xfffab387,
  magenta = 0xff80495c,
  grey = 0xff7f8490,
  teal = 0xff5a8b96,
  transparent = 0x00000000,

  bar = {
    bg = 0xFF0D1116,
    border = 0xff2c2e34,
  },
  popup = {
    bg = 0xF2232634,
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
