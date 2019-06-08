
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name     'archiv'
  authors  'Tobias Doll'
  email    'tobias.doll@dw.com'
  url      'https://github.com/tobysoby/archiv'
}

