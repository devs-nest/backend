#frozen_string_literal:true

namespace :skills do
desc "populate skills"

sks = ["Ableton", "Activitypub", "Actix", "Adonis", "Adobe Ae", "Aiscript", "Alpinejs", "Android Studio", "Angular", "Ansible", "Apollo", "Appwrite", "Arduino", "Astro", "Atom", "Adobe Au", "Autocad", "AWS", "Azul", "Azure", "Babel", "Bash", "Bevy", "Blender", "Bootstrap", "Bsd", "C", "Cs", "CPP", "Crystal", "Cassandra", "Clojure", "Cloudflare", "CMake", "Codepen", "Coffeescript", "CSS", "D3", "Dart", "Deno", "Devto", "Discord", "Bots", "Django", "Docker", "DotNet", "Dynamodb", "Eclipse", "Electron", "Elixir", "Emacs", "Ember", "Emotion", "Express", "Fastapi", "Fediverse", "Figma", "Firebase", "Flask", "Flutter", "Forth", "Fortran", "Gamemakerstudio", "Gatsby", "GCP", "Git", "Github", "Github Actions", "Gitlab", "Gherkin", "Go", "Gradle", "Godot", "Grafana", "Graphql", "Gtk", "Gulp", "Haskell", "Haxe", "Haxeflixel", "Heroku", "Hibernate", "HTML", "Idea", "Adobe Ai", "Instagram", "IPFS", "Java", "JavaScript", "Jenkins", "Jest", "JQuery", "Kafka", "Kotlin", "Ktor", "Kubernetes", "Laravel", "Latex", "Linkedin", "Linux", "Lit", "Lua", "Md", "Mastodon", "Material UI", "Matlab", "Maven", "Misskey", "Mongodb", "Mysql", "Neovim", "Nestjs", "Netlify", "Nextjs", "Nginx", "Nim", "Nodejs", "Nuxtjs", "Ocaml", "Octave", "Openshift", "Openstack", "Perl", "Photoshop", "Php", "Plan9", "Planetscale", "Postgres", "Postman", "Powershell", "Pr", "Prisma", "Processing", "Prometheus", "Pug", "Py", "Pytorch", "Qt", "R", "RabbitMQ", "Rails", "Raspberry Pi", "React", "Reactivex", "Redis", "Redux", "Regex", "Remix", "Replit", "Rocket", "Rollupjs", "ROS", "Ruby", "Rust", "Sass", "Spring", "Sqlite", "Stackoverflow", "Styled components", "Supabase", "Scala", "Selenium", "Sentry", "Sequelize", "Sketchup", "Solidity", "Solidjs", "Svelte", "Svg", "Swift", "Symfony", "Tailwind", "Tauri", "Tensorflow", "Threejs", "Twitter", "TypeScript", "Unity", "Unreal", "V", "Vala", "Vercel", "Vim", "Visual Studio", "Vite", "Vscode", "Vue", "Wasm", "Webflow", "Webpack", "Windicss", "Wordpress", "Workers", "XD", "Zig"]
sks_raw = "ableton\nactivitypub\nactix\nadonis\nae\naiscript\nalpinejs\nandroidstudio\nangular\nansible\napollo\nappwrite\narduino\nastro\natom\nau\nautocad\naws\nazul\nazure\nbabel\nbash\nbevy\nblender\nbootstrap\nbsd\nc\ncs\ncpp\ncrystal\ncassandra\nclojure\ncloudflare\ncmake\ncodepen\ncoffeescript\ncss\nd3\ndart\ndeno\ndevto\ndiscord\nbots\ndjango\ndocker\ndotnet\ndynamodb\neclipse\nelectron\nelixir\nemacs\nember\nemotion\nexpress\nfastapi\nfediverse\nfigma\nfirebase\nflask\nflutter\nforth\nfortran\ngamemakerstudio\ngatsby\ngcp\ngit\ngithub\ngithubactions\ngitlab\ngherkin\ngo\ngradle\ngodot\ngrafana\ngraphql\ngtk\ngulp\nhaskell\nhaxe\nhaxeflixel\nheroku\nhibernate\nhtml\nidea\nai\ninstagram\nipfs\njava\njs\njenkins\njest\njquery\nkafka\nkotlin\nktor\nkubernetes\nlaravel\nlatex\nlinkedin\nlinux\nlit\nlua\nmd\nmastodon\nmaterialui\nmatlab\nmaven\nmisskey\nmongodb\nmysql\nneovim\nnestjs\nnetlify\nnextjs\nnginx\nnim\nnodejs\nnuxtjs\nocaml\noctave\nopenshift\nopenstack\nperl\nps\nphp\nplan9\nplanetscale\npostgres\npostman\npowershell\npr\nprisma\nprocessing\nprometheus\npug\npy\npytorch\nqt\nr\nrabbitmq\nrails\nraspberrypi\nreact\nreactivex\nredis\nredux\nregex\nremix\nreplit\nrocket\nrollupjs\nros\nruby\nrust\nsass\nspring\nsqlite\nstackoverflow\nstyledcomponents\nsupabase\nscala\nselenium\nsentry\nsequelize\nsketchup\nsolidity\nsolidjs\nsvelte\nsvg\nswift\nsymfony\ntailwind\ntauri\ntensorflow\nthreejs\ntwitter\nts\nunity\nunreal\nv\nvala\nvercel\nvim\nvisualstudio\nvite\nvscode\nvue\nwasm\nwebflow\nwebpack\nwindicss\nwordpress\nworkers\nxd\nzig"

task populate: :environment do
  sks.zip(sks_raw.split("\n")) do |name, symb|
    svg = HTTParty.get("https://skillicons.dev/icons?i=#{symb}").response.body
    if Skill.create(name: name, logo: svg)
      p name
    else
      p "failed: #{name}"
    end
  end
end

  def check_username(username)
    username.match(/^(?!.*\.\.)(?!.*\.$)[^\W][\w.]{4,29}$/).nil?
  end
end