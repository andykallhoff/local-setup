
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

alias rs="rails s"
alias rc="rails c"
alias sd="sidekiq -C config/sidekiq-default.yml"
alias rcdb="bundle exec rails db:drop db:create && bundle exec rails db:migrate && bundle exec rails db:seed"

# rt = Run Tests
alias rt="RAILS_ENV='test' bundle exec rake test"
# st = Specific Test
alias st="RAILS_ENV=test bundle exec ruby -Itest"

eval "$(starship init zsh)"
