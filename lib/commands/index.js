// Generated by CoffeeScript 1.6.3
(function() {
  var Compiler, Index, fork;

  Compiler = require('../commands/compiler');

  fork = (require('child_process')).fork;

  module.exports = Index = (function() {
    function Index(the, cli) {
      var _this = this;
      this.the = the;
      this.cli = cli;
      process.on('exit', function() {
        _this.compiler.polvo.kill();
        return _this.snapshooter.kill();
      });
      this.compiler = new Compiler(this.the, this.cli, true, true);
      this.compiler.polvo.on('message', function(data) {
        if (data.channel === null && data.msg === 'server.started') {
          return _this.start_snapshooter();
        }
      });
    }

    Index.prototype.start_snapshooter = function() {
      var o, opts, output, snapshooter_path, url, _ref;
      console.log('Start indexing pages..'.magenta);
      snapshooter_path = path.join(this.the.root, 'node_modules', 'snapshooter');
      snapshooter_path = path.join(snapshooter_path, 'bin', 'snapshooter');
      output = (o = this.cli.argv.index === true) ? 'public_indexed' : o;
      url = (_ref = this.cli.argv.url) != null ? _ref : 'localhost:11235';
      opts = ['-i', url, '-o', output];
      if (this.cli.argv.snapshooter != null) {
        opts = opts.concat([].concat(this.cli.argv.snapshooter.split(' ')));
      }
      this.snapshooter = fork(snapshooter_path, opts, {
        cwd: this.the.app_root
      });
      return this.snapshooter.on('exit', function() {
        return process.exit();
      });
    };

    return Index;

  })();

}).call(this);

/*
//@ sourceMappingURL=index.map
*/