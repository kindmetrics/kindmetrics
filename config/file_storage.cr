require "baked_file_system"

class FileStorage
  extend BakedFileSystem

  bake_folder "../src/marketing"
  bake_folder "../src/pages/faq"
end
