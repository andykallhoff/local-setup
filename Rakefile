ENV['HOMEBREW_CASK_OPTS'] = "--appdir=/Applications"

def brew_install(package, *args)
  versions = `brew list #{package} --versions`
  options = args.last.is_a?(Hash) ? args.pop : {}

  # if brew exits with error we install tmux
  if versions.empty?
    sh "brew install #{package} #{args.join ' '}"
  elsif options[:requires]
    # brew did not error out, verify tmux is greater than 1.8
    # e.g. brew_tmux_query = 'tmux 1.9a'
    installed_version = versions.split(/\n/).first.split(' ').last
    unless version_match?(options[:requires], installed_version)
      sh "brew upgrade #{package} #{args.join ' '}"
    end
  end
end

def version_match?(requirement, version)
  # This is a hack, but it lets us avoid a gem dep for version checking.
  # Gem dependencies must be numeric, so we remove non-numeric characters here.
  matches = version.match(/(?<versionish>\d+\.\d+)/)
  return false unless matches.length > 0
  Gem::Dependency.new('', requirement).match?('', matches.captures[0])
end

def install_github_bundle(user, package)
  unless File.exist? File.expand_path("~/.vim/bundle/#{package}")
    sh "git clone https://github.com/#{user}/#{package} ~/.vim/bundle/#{package}"
  end
end

def brew_cask_install(package, *options)
  output = `brew cask info #{package}`
  return unless output.include?('Not installed')

  sh "brew cask install #{package} #{options.join ' '}"
end

def step(description)
  description = "-- #{description} "
  description = description.ljust(80, '-')
  puts
  puts "\e[32m#{description}\e[0m"
end

def app_path(name)
  path = "/Applications/#{name}.app"
  ["~#{path}", path].each do |full_path|
    return full_path if File.directory?(full_path)
  end

  return nil
end

def app?(name)
  return !app_path(name).nil?
end

def get_backup_path(path)
  number = 1
  backup_path = "#{path}.bak"
  loop do
    if number > 1
      backup_path = "#{backup_path}#{number}"
    end
    if File.exists?(backup_path) || File.symlink?(backup_path)
      number += 1
      next
    end
    break
  end
  backup_path
end

def link_file(original_filename, symlink_filename)
  original_path = File.expand_path(original_filename)
  symlink_path = File.expand_path(symlink_filename)
  if File.exists?(symlink_path) || File.symlink?(symlink_path)
    if File.symlink?(symlink_path)
      symlink_points_to_path = File.readlink(symlink_path)
      return if symlink_points_to_path == original_path
      # Symlinks can't just be moved like regular files. Recreate old one, and
      # remove it.
      ln_s symlink_points_to_path, get_backup_path(symlink_path), :verbose => true
      rm symlink_path
    else
      # Never move user's files without creating backups first
      mv symlink_path, get_backup_path(symlink_path), :verbose => true
    end
  end
  ln_s original_path, symlink_path, :verbose => true
end

def unlink_file(original_filename, symlink_filename)
  original_path = File.expand_path(original_filename)
  symlink_path = File.expand_path(symlink_filename)
  if File.symlink?(symlink_path)
    symlink_points_to_path = File.readlink(symlink_path)
    if symlink_points_to_path == original_path
      # the symlink is installed, so we should uninstall it
      rm_f symlink_path, :verbose => true
      backups = Dir["#{symlink_path}*.bak"]
      case backups.size
      when 0
        # nothing to do
      when 1
        mv backups.first, symlink_path, :verbose => true
      else
        $stderr.puts "found #{backups.size} backups for #{symlink_path}, please restore the one you want."
      end
    else
      $stderr.puts "#{symlink_path} does not point to #{original_path}, skipping."
    end
  else
    $stderr.puts "#{symlink_path} is not a symlink, skipping."
  end
end

def filemap(map)
  map.inject({}) do |result, (key, value)|
    result[File.expand_path(key)] = File.expand_path(value)
    result
  end.freeze
end

COPIED_FILES = filemap(
  'vimrc.local'         => '~/.vimrc.local',
  'vimrc.bundles.local' => '~/.vimrc.bundles.local',
  'tmux.conf.local'     => '~/.tmux.conf.local'
)

LINKED_FILES = filemap(
  'vim'           => '~/.vim',
  'tmux.conf'     => '~/.tmux.conf',
  'vimrc'         => '~/.vimrc',
  'vimrc.bundles' => '~/.vimrc.bundles'
)

# Portions of the installation are order dependent!
# 1) RVM
# 2) Homebrew
# 3) Vim
# At this point the others are no longer order dependent
namespace :install do
  desc 'Install RVM'
  task :rvm do
    step 'RVM'
    sh '\curl -sSL https://get.rvm.io | bash && source /Users/andykallhoff/.rvm/scripts/rvm'
  end

  desc 'Update or Install Brew'
  task :brew do
    step 'Homebrew'
    unless system('which brew > /dev/null || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')
      raise "Homebrew must be installed before continuing."
    end
    sh 'echo \'eval "$(/opt/homebrew/bin/brew shellenv)"\' >> /Users/andykallhoff/.zprofile'
    sh 'eval "$(/opt/homebrew/bin/brew shellenv)"'
  end

  desc 'Install Vim'
  task :vim do
    step 'vim'
    brew_install 'vim'
  end
  
  desc 'Setup .zshrc'
  task :setup_zshrc do
    step 'setup_zshrc'
    sh 'echo >> ~/.zshrc'
    sh 'echo "alias rs=\"rails s\"" >> ~/.zshrc'
    sh 'echo "alias rc=\"rails c\"" >> ~/.zshrc'
    sh 'echo "alias sd=\"sidekiq -C config/sidekiq-default.yml\"" >> ~/.zshrc'
    sh 'echo "alias rcdb=\"bundle exec rails db:drop db:create && bundle exec rails db:migrate && bundle exec rails db:seed\"" >> ~/.zshrc'
    sh 'echo "alias rt=\"RAILS_ENV=test bundle exec rake test\"" >> ~/.zshrc'
    sh 'echo "# st = Specific Test" >> ~/.zshrc'
    sh 'echo "# usages: RAILS_ENV=test bundle exec ruby -Itest path/to/file" >> ~/.zshrc'
    sh 'echo "# usages: RAILS_ENV=test bundle exec ruby -Itest path/to/file --name name_of_test" >> ~/.zshrc'
    sh 'echo "# usages: st path/to/file --name name_of_test" >> ~/.zshrc'
    sh 'echo "alias st=\"RAILS_ENV=test bundle exec ruby -Itest\"" >> ~/.zshrc'
    sh 'echo >> ~/.zshrc'
  end
  
  desc 'Install The Silver Searcher'
  task :the_silver_searcher do
    step 'the_silver_searcher'
    brew_install 'the_silver_searcher'
  end

  desc 'Install ctags'
  task :ctags do
    step 'ctags'
    brew_install 'ctags'
  end

  desc 'Install reattach-to-user-namespace'
  task :reattach_to_user_namespace do
    step 'reattach-to-user-namespace'
    brew_install 'reattach-to-user-namespace'
  end

  #desc 'Install tmux'
  #task :tmux do
  #  step 'tmux'
  #  # tmux copy-pipe function needs tmux >= 1.8
  #  brew_install 'tmux', :requires => '>= 2.1'
  #end

  desc 'Install Starship'
  task :starship do
    step 'starship'
    # https://starship.rs/guide/#%F0%9F%9A%80-installation
    brew_install 'starship'
    sh 'echo "eval \"$(starship init zsh)\"" >> ~/.zshrc'
  end

  desc 'Install Homebrew Services'
  task :homebrew_services do
    step 'homebrew_services'
    sh 'brew tap homebrew/services'
  end

  desc 'Install Node'
  task :node do
    step 'node'
    brew_install 'node'
  end

  desc 'Install Yarn'
  task :yarn do
    step 'yarn'
    brew_install 'yarn'
  end

  desc 'Install Redis'
  task :redis do
    step 'redis'
    brew_install 'redis'
    sh 'brew services start redis'
  end

  desc 'Install Postgresql'
  task :postgresql do
    step 'postgresql'
    brew_install 'postgresql'
    sh 'brew services start postgresql'
  end

  desc 'Install Mysql'
  task :mysql do
    step 'mysql'
    brew_install 'mysql'
    sh 'brew services start mysql'
  end

  desc 'Install Elasticsearch'
  task :elasticsearch do
    step 'elasticsearch'
    sh 'brew tap elastic/tap'
    brew_install 'elastic/tap/elasticsearch-full'
    sh 'brew services start elasticsearch'
  end

  #desc 'Install MacVim'
  #task :macvim do
  #  step 'MacVim'
  #  unless app? 'MacVim'
  #    brew_cask_install 'macvim'
  #  end

  #  bin_dir = File.expand_path('~/bin')
  #  bin_vim = File.join(bin_dir, 'vim')
  #  unless ENV['PATH'].split(':').include?(bin_dir)
  #    puts 'Please add ~/bin to your PATH, e.g. run this command:'
  #    puts
  #    puts %{  echo 'export PATH="~/bin:$PATH"' >> ~/.bashrc}
  #    puts
  #    puts 'The exact command and file will vary by your shell and configuration.'
  #    puts 'You may need to restart your shell.'
  #  end

  #  FileUtils.mkdir_p(bin_dir)
  #  unless File.executable?(bin_vim)
  #    File.open(bin_vim, 'w', 0744) do |io|
  #      io << <<-SHELL
  #        #!/bin/bash
  #        exec /Applications/MacVim.app/Contents/MacOS/Vim "$@"
  #      SHELL
  #    end
  #  end
  #end

  desc 'Install Vundle'
  task :vundle do
    step 'vundle'
    install_github_bundle 'VundleVim','Vundle.vim'
    sh '/usr/local/bin/vim -c "PluginInstall!" -c "q" -c "q"'
    #This is the macvim version
    #sh '~/bin/vim -c "PluginInstall!" -c "q" -c "q"'
  end
end

desc 'Install these config files.'
task :install do
  Rake::Task['install:rvm'].invoke
  Rake::Task['install:brew'].invoke
  Rake::Task['install:vim'].invoke
  Rake::Task['install:setup_zshrc'].invoke
  Rake::Task['install:the_silver_searcher'].invoke
  Rake::Task['install:ctags'].invoke
  Rake::Task['install:reattach_to_user_namespace'].invoke
  #Rake::Task['install:tmux'].invoke
  Rake::Task['install:starship'].invoke
  Rake::Task['install:homebrew_services'].invoke
  Rake::Task['install:node'].invoke
  Rake::Task['install:yarn'].invoke
  Rake::Task['install:redis'].invoke
  Rake::Task['install:postgresql'].invoke
  Rake::Task['install:mysql'].invoke
  Rake::Task['install:elasticsearch'].invoke
  #Rake::Task['install:macvim'].invoke

  # TODO install gem ctags?
  # TODO run gem ctags?

  step 'symlink'

  LINKED_FILES.each do |orig, link|
    link_file orig, link
  end

  COPIED_FILES.each do |orig, copy|
    cp orig, copy, :verbose => true unless File.exist?(copy)
  end

  # Install Vundle and bundles
  Rake::Task['install:vundle'].invoke

  puts "  Enjoy!"
  puts
end

desc 'Uninstall these config files.'
task :uninstall do
  step 'un-symlink'

  # un-symlink files that still point to the installed locations
  LINKED_FILES.each do |orig, link|
    unlink_file orig, link
  end

  # delete unchanged copied files
  COPIED_FILES.each do |orig, copy|
    rm_f copy, :verbose => true if File.read(orig) == File.read(copy)
  end

  step 'homebrew'
  puts
  puts 'Manually uninstall homebrew if you wish: https://gist.github.com/mxcl/1173223.'

  #step 'macvim'
  #puts
  #puts 'Run this to uninstall MacVim:'
  #puts
  #puts '  rm -rf /Applications/MacVim.app'
end

task :default => :install
