local n = require('test.functional.testnvim')()
local Screen = require('test.functional.ui.screen')

local clear = n.clear
local command = n.command
local feed = n.feed

describe('update_menu notification', function()
  local screen

  before_each(function()
    clear()
    screen = Screen.new()
  end)

  local function expect_sent(expected)
    screen:expect {
      condition = function()
        if screen.update_menu ~= expected then
          if expected then
            error('update_menu was expected but not sent')
          else
            error('update_menu was sent unexpectedly')
          end
        end
      end,
      unchanged = not expected,
    }
  end

  it('should be sent when adding a menu', function()
    command('menu Test.Test :')
    expect_sent(true)
  end)

  it('should be sent when deleting a menu', function()
    command('menu Test.Test :')
    screen.update_menu = false

    command('unmenu Test.Test')
    expect_sent(true)
  end)

  it('should not be sent unnecessarily', function()
    feed('i12345<ESC>:redraw<CR>')
    expect_sent(false)
  end)
end)
