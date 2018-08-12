# encoding: UTF-8
# frozen_string_literal: true

require "rake/testtask"

ENV["TESTOPTS"] = "--verbose"
Rake::TestTask.new { |t| t.libs << "test" }

namespace "javascripts" do
  task "build" do
    require "json"
    require "open3"

    def run(*args)
      puts(*args)
      stdout, stderr, exit_status = Open3.capture3(*args)
      raise stderr.strip.empty? ? stdout : stderr unless exit_status.success?
      stdout
    end

    def load_all(url)
      max = run("curl --head #{ url }").match(/Link:[^\n\r]+/).to_s.scan(/page=(\d+)/).flatten.map(&:to_i).uniq.max || 1
      (1..max).reduce([]) { |ary, p| ary + JSON.parse(run("curl #{ url }?page=#{ p }")) }
    end

    def clone_repository(url, branch, dir)
      run "[ -d #{ dir } ] || git clone --single-branch --branch #{ branch } --depth 1 --no-hardlinks #{ url } #{ dir }"
    end

    def install_node_modules(dir)
      run "[ -d #{ dir } -a ! -d #{ dir }/node_modules ] && cd #{ dir } && npm install --only=production --ignore-scripts || true"
    end

    def build_template_compiler(engine, engine_dir, engine_version, output_file)
      run "[ -f #{ output_file } ] || (node support/browserify-#{ engine }.js #{ engine_dir } #{ engine_version } #{ output_file } &&
                                     node support/minify-#{ engine }.js #{ output_file })"
    end

    def build_template_runtime(engine, engine_runtime_dir, engine_version, output_file)
      run "[ -f #{ output_file }.js ] || (node support/browserify-#{ engine }-runtime.js #{ engine_runtime_dir } #{ engine_version } #{ output_file }.js &&
                                          node support/minify-#{ engine }.js #{ output_file }.js #{ output_file }.min.js)"
    end

    def copy_license_file(engine, engine_dir, engine_version, output_file)
      run "[ ! -f #{ output_file } -a -f #{ engine_dir }/LICENSE ] && cp #{ engine_dir }/LICENSE #{ output_file } || true"
    end

    tags  = load_all("https://api.github.com/repos/pugjs/pug/releases").map { |x| x.fetch("tag_name") }
    tags += load_all("https://api.github.com/repos/pugjs/pug/tags").map { |x| x.fetch("name") }
    tags.uniq.each do |tag|
      if tag.start_with?("1")
        version = tag
        clone_repository        "https://github.com/pugjs/pug.git", tag, "tmp/jade-#{ version }"
        install_node_modules    "tmp/jade-#{ version }"
        build_template_compiler :jade, "tmp/jade-#{ version }", version, "vendor/jade-#{ version }.min.js"
        build_template_runtime  :jade, "tmp/jade-#{ version }", version, "vendor/jade-runtime-#{ version }"
        copy_license_file       :jade, "tmp/jade-#{ version }", version, "vendor/jade-#{ version }-license"
        copy_license_file       :jade, "tmp/jade-#{ version }", version, "vendor/jade-runtime-#{ version }-license"

      elsif tag.match?(/\A(?:pug@|2)/) && !tag.match?(/alpha/)
        version = tag.gsub(/\Apug@/, "")

        next if version == "2.0.0" # Pug 2.0.0 is broken. See https://github.com/pugjs/pug/issues/2979

        # Try to remove an extra dot in versions like "2.0.0-beta.12".
        # This is just a typo:                                   ^
        # I try to fix it so user will not be confused why some beta versions
        # are named like "2.0.0-beta.12" and others like "2.0.0-beta5".
        version = version.gsub(/\A(2\.0\.0-beta)\.(\d+)\z/, "\\1\\2")
        clone_repository        "https://github.com/pugjs/pug.git", tag, "tmp/pug-#{ version }"
        install_node_modules    "tmp/pug-#{ version }"
        install_node_modules    "tmp/pug-#{ version }/packages/pug"
        build_template_compiler :pug, "tmp/pug-#{ version }", version, "vendor/pug-#{ version }.min.js"
        copy_license_file       :pug, "tmp/pug-#{ version }", version, "vendor/pug-#{ version }-license"
        copy_license_file       :pug, "tmp/pug-#{ version }/packages/pug", version, "vendor/pug-#{ version }-license"
      end
    end

    tags = load_all("https://api.github.com/repos/pugjs/pug-runtime/tags").map { |x| x.fetch("name") }
    tags.uniq.each do |tag|
      next unless tag.start_with?("2")
      version = tag
      clone_repository        "https://github.com/pugjs/pug-runtime.git", tag, "tmp/pug-runtime-#{ version }"
      build_template_runtime  :pug, "tmp/pug-runtime-#{ version }", version, "vendor/pug-runtime-#{ version }"
      copy_license_file       :pug, "tmp/pug-runtime-#{ version }", version, "vendor/pug-runtime-#{ version }-license"
    end
  end
end
