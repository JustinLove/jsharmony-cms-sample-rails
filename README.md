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

Navigate to Sites, select `Manage Site`. For `01 / Local FS` Select `Edit`

  - change the Path setting to reflect the absolute path on your local filesystem.
  - Check the params to ensure the address of the rails server is correct for how you are running it.

Change to `Page Templates` tab and `+ Add` with

`Basic Page`, `Basic Page`, `REMOTE`, `%%%base_url%%%/cms_templates/basic_page.html`

Hit `Save`

Select `Pages` on the top menu. On both `Home` and `Style Guide`,

  - Select `Page Properties`
  - Change Template to `Basic Page`
  - Save properties

## Outline of How This Was Made

### Rails setup

(install rails and prereqs as needed)

`rails new rails_jsh`

Added a token random_numbers controller and view.

Added a cms_templates controller, and an basic_page view, with wildcard routing

`get "/cms_templates/*template", to: "cms_templates#index"`

### jsHarmony-CMS setup

(install jsharmony-cli from npm as needed)

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

Add models/sql/objects/deployment.json (see file)

Create the files

    /views/jsh_cms_editor.css.ext.ejs
    /views/jsh_cms_editor.ext.ejs

Since these are new files, restart the server if it was running.

Navigate to Sites, select `Manage Site`. For `01 / Local FS` Select `Edit`

Change to `Page Templates` tab and `+ Add` with

`Basic Page`, `Basic Page`, `REMOTE`, `%%%base_url%%%/cms_templates/basic_page.html`

Hit `Save`

Select `Pages` on the top menu. On both `Home` and `Style Guide`,

  - Select `Page Properties`
  - Change Template to `Basic Page`
  - Save properties


? Can template be defined a similar manner to default deployment