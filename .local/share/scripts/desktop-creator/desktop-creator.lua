#!/bin/lua

local function script_path()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*/)")
end

local lua_version = _VERSION:match("%d+%.%d+")
local lua_modules_path = script_path().."/lua_modules"
package.path = lua_modules_path.."/share/lua/"..lua_version.."/?.lua;"..lua_modules_path.."/share/lua/"..lua_version.."/?/init.lua;"..package.path
package.cpath = lua_modules_path.."/lib/lua/"..lua_version.."/?.so;"..package.cpath

local function needs(pkg, rock_name)
  local out
  xpcall(
    function() out = require(pkg) end,
    function()
      if rock_name == nil then
        print("FATAL: Missing required package '"..pkg.."'. No luarock is known.")
        os.exit(1)
      end

      -- Install package with luarocks
      print("Missing required package: '"..pkg.."'. Installing '"..rock_name.."' from luarocks into script tree...")
      os.execute("luarocks --tree "..lua_modules_path.." install "..rock_name)
      out = require(pkg)
    end
  )

  return out
end

local argparse = needs("argparse", "argparse")
local path = needs("pl.path", "penlight")
local utils = needs("pl.utils", "penlight")

local parser = argparse("desktop-creator", "Creates desktop files under ~/.local/share/applications/ for a given executable.")
parser:argument("executable", "Path to executable.")
  :convert(function(executable)
    -- executable is the path the user provided
    return path.abspath(executable)
  end)
parser:option("-n --name", "Human-readable name of application.")
parser:option("-c --comment", "Comment to show in application menu.", "Created with desktop-creator-lua")
parser:option("-d --start-in", "The working directory to use when running this application.")
parser:option("-i --icon", "The name or path of the icon to use.")
parser:flag("-t --terminal", "Marks this application to run in a terminal.", false)

local args = parser:parse()

if args.name == nil then
  parser:error("Name must be provided!")
end

if args.start_in == nil then
  args.start_in = path.dirname(args.executable)
end

local desktop_entry = string.format([[
# Created by desktop-creator-lua

[Desktop Entry]
type=Application
Version=1.0
Name=%s
Comment=%s
Path=%s
Exec=%s
Terminal=%s
]],
  args.name,
  args.comment,
  args.executable,
  args.start_in,
  args.terminal and "true" or "false"
)

-- Icon
if args.icon ~= nil then
  local icon_line = string.format("Icon=%s\n", args.icon)
  desktop_entry = desktop_entry..icon_line
end

-- TODO: Interactive categories

local exe_name = path.basename(args.executable)
local desktop_file_name = exe_name..".desktop"
local home_dir = os.getenv("HOME")
local desktop_file_path = path.join(home_dir, ".local", "share", "applications", desktop_file_name)
if path.exists(desktop_file_path) then
  io.stderr:write("Desktop file "..desktop_file_path.." already exists!\n")
  os.exit(1)
end
utils.writefile(desktop_file_path, desktop_entry)

print("Created desktop entry in "..desktop_file_path)

