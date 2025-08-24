-- ----------------------------------------------------------------------------
--  Filename: ~/.config/yazi/init.lua
--  Yazi Docs: https://yazi-rs.github.io/docs/quick-start
--  Yazi Github: https://github.com/sxyazi/yazi
-- ----------------------------------------------------------------------------

require("auto-layout")

function Status:render(area)
	self.area = area

	local line = ui.Line { self:percentage(), self:position() }
	return {
		ui.Paragraph(area, { line }):align(ui.Paragraph.CENTER),
	}
end
