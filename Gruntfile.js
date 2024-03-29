module.exports = function(grunt) {

	grunt.initConfig({

		// Import package manifest
		pkg: grunt.file.readJSON("jcrop-fileinput.json"),

		// Banner definitions
		meta: {
			banner: "/*\n" +
				" *  <%= pkg.title || pkg.name %> - v<%= pkg.version %>\n" +
				" *  <%= pkg.description %>\n" +
				" *  <%= pkg.homepage %>\n" +
				" *\n" +
				" *  Made by <%= pkg.author.name %>\n" +
				" *  Under <%= pkg.licenses[0].type %> License\n" +
				" */\n"
		},

		// Lint definitions
		jshint: {
			files: ["src/jcrop-fileinput.js"],
			options: {
				jshintrc: ".jshintrc"
			}
		},

		// Minify definitions
		uglify: {
			my_target: {
				src: ["dist/jcrop-fileinput.js"],
				dest: "dist/jcrop-fileinput.min.js"
			},
			options: {
				banner: "<%= meta.banner %>"
			}
		},

		// CoffeeScript compilation
		coffee: {
			compile: {
				files: {
					"dist/jcrop-fileinput.js": "src/jcrop-fileinput.coffee"
				}
			}
		},

    sass: {
      dist: {
        files: {
          "dist/jcrop-fileinput.css": "src/jcrop-fileinput.scss"
        }
      }
    },

    // Watch
    watch: {
      options: {
        livereload: true
      },
      coffee: {
        files: "src/jcrop-fileinput.coffee",
        tasks: ["coffee"]
      },
      sass: {
        files: "src/jcrop-fileinput.scss",
        tasks: ["sass"]
      }
    }

	});

	grunt.loadNpmTasks("grunt-contrib-jshint");
	grunt.loadNpmTasks("grunt-contrib-uglify");
	grunt.loadNpmTasks("grunt-contrib-coffee");
	grunt.loadNpmTasks("grunt-contrib-sass");
	grunt.loadNpmTasks("grunt-contrib-watch");

	grunt.registerTask("default", ["jshint", "coffee", "sass", "uglify"]);
};
