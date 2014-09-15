require 'liquid'
require 'mail'
require 'rugged'
require 'yaml'

config = YAML.load_file('config.yml')

mail = Mail.read_from_string(STDIN.read)

params = {
  'subject' => mail.subject,
  'slug' => mail.subject.downcase.gsub(/\W+/, ' ').strip.tr(' ', '-'),
  'date' => mail.date,
  'body' => mail.body.to_s,
  'from' => mail.from
}
path_template    = Liquid::Template.parse(config['file']['path'])
content_template = Liquid::Template.parse(config['file']['content'])
message_template = Liquid::Template.parse(config['git']['message'])
path    = path_template.render(params)
content = content_template.render(params)
message = message_template.render(params)

repo = Rugged::Repository.new(config['git']['repo'])
oid = repo.write(content, :blob)
index = repo.index
index.read_tree(repo.head.target.tree)
index.add(path: path, oid: oid, mode: 0100644)

Rugged::Commit.create(repo, {
  tree: index.write_tree(repo),
  message: message,
  author: {
    email: mail.from[0],
    name: mail.from[0],
    time: mail.date.to_time
  },
  committer: {
    email: config['git']['email'],
    name: config['git']['name'],
    time: Time.now
  },
  parents: [ repo.head.target ].compact,
  update_ref: 'HEAD'
})

remote = repo.remotes[config['git']['remote']]
remote.push([ repo.head.name ]) if remote
