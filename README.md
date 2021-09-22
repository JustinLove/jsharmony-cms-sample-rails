# jsHarmony-CMS/Rails Integration sample

## Using this example

### Rails

    bundle install
    rails s

### jsHarmony-CMS

#### Installation

Follow instructions at [https://github.com/apHarmony/jsharmony-cms-empty]

#### Site Setup

Log in and go to Sites. [https://localhost:8081]

Select `+ Add Site`

Enter a name, make active, and `Save`

Under `Deployment Targets` select `+ Add Deployment Target`

- Enter a name such as `01 / Rails Public`
- active status.
- Deployment Type: `Local Filesystem`
- Enter the full path where you want to publish files, e.g. `c:/wk/jsharmony-cms-sample-rails/public/cms/`
  - **IMPORTANT**: Do not use the `public` directory. The CMS manages all files below here, including deleteing files.

Select `Save`, and close the deployment targets window.

Change to `Page Templates` tab and `+ Add` with

`basic_page`, `Basic Page`, `REMOTE`, `http://localhost:3000/cms_templates/basic_page.html`

Hit `Save` and change back to the `Overview` tab.

- Set `Default Page Template` to `Basic Page` 
- Set `Default Preview/Editor` to `01 / Rails Public`

Hit `Save` and close the site window.

Still in the Sites section, Press the `Checkout` button to activate the site you just created for editing.

This automatically changes you to the `Revisions` section on the top menu.

Select `Clone` for `Release/master` and enter a branch name. Commiting will automatically change you the Pages tab.

#### Adding Pages

Select `Pages` from the top menu if not already there.

You will actually be on the `Sitemap View` subtab, editing the default sitemap.

Right-click the `(Root)` item and select `Add Child Page`, such as `About`.

Choosing `Edit Page Content` should show the page in the rails application template. Click on the title or body to edit, and `Save` when happy.

You can build out the content as much as you like, but one page is sufficient to demonstrate the publishing and integration process.

#### Publishing Content

Got to `Publish` on the top menu, `Publish` subtab, and select `+ Add Deployment`

Select `Publish the Current Checked-out Revision` (a full workflow would merge to master and then publish that, but this is fine for testing)

This should set the proper default values for the publish screen. Select `Sechedule Deployment`

Your rails project should now have a `public/cms/about/index.html`, and it should be directly viewable at [http://localhost:3000/about/] (`application.rb` has an additional static middleware to handle the `cms` subdirectory)

#### CMS Redirects

Download the [jsHarmony Redirects Component](https://www.jsharmonycms.com/web/media/templates/jshcms_redirects.zip) and extract into your site's SFTP folder.  This contains a `jshcms_redirects` component that exports the Redirects as JSON into a file named `jshcms_redirects.json` in the root of the site.  A `site_config.json` file is also included that sets the `redirect_listing_path` parameter to the new file.

Find the URL to the SFTP folder under the `Site Config` tab:
  1. Open the `Sites` tab
  2. Click `Configure Site` on the target site
  3. Select the `Site Config` tab

Copy the *contents* of the `jshcms_redirects` plugin into the SFTP folder. (No top level `jshcms_redirects` folder)

Publish the site again. If configured correctly, you should see `public\cms\jshcm_redirects.json` in the publish log.

You can also manage arbitrary redirects under the `Pages`, `Redirects` menu. (Every change needs a publish to be visible on the rails site)

#### Adding Media

Select `Media` from the top menu. Choose `+ Add` and upload an image.

Now Select `Pages` and edit your about page. Click into the body text area. Now you can select the image icon or the Insert->Image menu. Click the "window with up-arrow" icon to open the media browser and pick your image.

Save the page and publish the site again to view the updated page from the application.

#### Adding Components

Go back to top level `Sites` tab, and edit your site.

Select the `Components` tab.

`+ Add` a new REMOTE template. Call it something like `googlemap`. For URL, enter `http://localhost:3000/cms_components/googlemap.html` and `Save`

Now if you edit a page and click into the editor, the `Component` menu will have Google Map as an option. One quirk of this component is that map preview will appear in a new tab, but once published it will appear inline.

## Outline of How This Was Made

(install rails and prereqs as needed)

`rails new rails_jsh`

Added a token random_numbers controller and view.

Added a cms_templates controller, and a basic_page view, with wildcard routing

`get "/cms_templates/*template", to: "cms_templates#index"`

See the view file for required contents. There is also a cms_templates_helper that has the cms javascript tags, and a stock cms javascript file `jsHarmonyCmsClient.min.js`. An access token needs to be configured to access the cms server for editor integration, see `config/application.rb`

Added a cms_components controller, with wildcard routing. This controller is nearly the same as templates, but components have no layout applied.

`get "/cms_components/*template", to: "cms_components#index"`

The `app/views/cms_components/googlemap.html.erb` is an `.erb`. It uses a non-ERB partial with the EJS content in order to avoid escaping each tag. It also uses a partial for the javascript in order to load and JSON-escape the contents.

`config/application.rb` loads additional middleware. A second instance of the static server provides the `cms` subdirectory without the `cms` path in the urls. `CmsRouterMiddleware` is placed early in the chain so that it can perform cms-configured redirects, and pass down the modified urls where appropropriate.

## Limitations and Points for extension

- Redirects are re-loaded on every request. It could be done by checking less often, hooking up a filesystem watcher, or simply restarting the app when new content is published.
- Templates are captured at publish time; if the rails templates change you will need to republish. **This includes asset pipeline fingerprints, so republishing will always be required when assets change** Alternately, it could be reworked so that the CMS publishes body content, and a rails controller inserts the appropriate body into the current template.
- Sample does not include many CMS features, such as menus, typical components, separate editor/publish templates, custom template attributes, etc.