// Generated by CoffeeScript 1.6.2
(function() {
  var Controller, path;

  path = require('path');

  module.exports = Controller = (function() {
    var fs;

    fs = require('fs');

    function Controller(the, name) {
      var contents, controllers, filepath, model_name, model_name_lc, name_camel, name_lc, tmpl;

      this.the = the;
      name_camel = name.camelize();
      name_lc = name.toLowerCase();
      model_name = name.singularize().camelize();
      model_name_lc = model_name.toLowerCase();
      tmpl = path.join(this.the.root, 'cli', 'templates', 'mvc');
      tmpl = path.join(tmpl, 'controller.coffee');
      controllers = path.join(this.the.app_root, 'src', 'app', 'controllers');
      filepath = path.join(controllers, "" + (name.toLowerCase()) + ".coffee");
      contents = (fs.readFileSync(tmpl)).toString();
      contents = contents.replace(/~NAME_CAMEL/g, name_camel);
      contents = contents.replace(/~NAME_LC/g, name_lc);
      contents = contents.replace(/~MODEL_CAMEL/g, model_name);
      contents = contents.replace(/~MODEL_LCASE/g, model_name_lc);
      if (!fs.existsSync(filepath)) {
        fs.writeFileSync(filepath, contents);
        console.log(("" + 'Created'.bold + " " + filepath).green);
      } else {
        console.log(("" + 'Already exists'.red.bold + " " + filepath).green);
      }
    }

    return Controller;

  })();

}).call(this);

/*
//@ sourceMappingURL=controller.map
*/