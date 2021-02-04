# jsHarmony-CMS/Rails Integration sample

## Using this example

### Rails

    cd rails_jsh
    bundle install
    rails s

### jsHarmony

    cd jsharmony_rails
    yarn install
    node node_modules/jsharmony-factory/create.js

Take note of initial login name and password.


## Outline of How This Was Made

### Rails setup

`rails new rails_jsh`

Addeded a token random_numbers controller and view

### jsHarmony-CMS setup

`jsharmony create factory`

- SQLite
- No Client Portal

`yarn add jsharmony-cms`

Edit `app.js`, replacing instances of factory with cms.

`yarn add jsharmony-image-sharp`

Edit `app.config.js` adding:

`  jsh.Extensions.image = require('jsharmony-image-sharp');`

Start the server

`./nstart.cmd`

There will be many warnings, but we need to run the web interface to run the CMS setup scripts to fix them.
Log in to the web interface (default [http://localhost:8080]) with the credentials from the create step.
Navigate to Developer -> DB Script
Under jsHarmonyCMS, run
  - `init`
  - `restructure`
  - `init_data`
  - `sample_data`

You should now be able to quit the server and restart without errors.