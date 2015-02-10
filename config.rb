require "sass"
require "compass/import-once/activate"

# Section: Default Properties
# ---------------------------
project_type = :stand_alone
relative_assets = true
disable_warnings = false
preferred_syntax = :sass
line_comments = true

# Directories
css_dir = "css"
images_dir = "images"

# Paths
project_path = "dev"
css_path = "#{project_path}/#{css_dir}"
css_dir = "#{project_path}/#{images_dir}"

# Http Paths
http_path = "/"
http_stylesheets_dir = "css"
http_images_dir = "images"
