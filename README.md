Lonely Planet Batch Processor
===================

### Setup ###
```
Install ruby 2.2.3 or change ruby version in ruby-version file.
bundle install
```

### For Running batch ###

```
ruby batch.rb taxonomy.xml destination.xml -o output-directory

or 

ruby batch.rb -help
```

### Tests ###

```
rake spec
```
