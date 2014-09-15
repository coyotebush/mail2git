require 'liquid'
require 'mail'
require 'rugged'
require 'yaml'

config = YAML.load_file('config.yml')

mail = Mail.read_from_string(STDIN.read)

from_addr = mail.from[0]
from_name = mail['from'].display_names[0] if mail['from']
from_name = from_addr if from_name.nil? or from_name.strip.empty?
slug = mail.subject.downcase.gsub(/\W+/, ' ').strip.tr(' ', '-')
params = {
  'subject' => mail.subject, 'slug' => slug, 'date' => mail.date,
  'from' => from_name, 'body' => mail.body.to_s
}

path    = Liquid::Template.parse(config['file']['path']).render(params)
content = Liquid::Template.parse(config['file']['content']).render(params)
message = Liquid::Template.parse(config['git']['message']).render(params)

repo = Rugged::Repository.new(config['git']['repo'])
oid = repo.write(content, :blob)
index = repo.index
index.read_tree(repo.head.target.tree)
index.add(path: path, oid: oid, mode: 0100644)

Rugged::Commit.create(repo, {
  tree: index.write_tree(repo),
  message: message,
  author: {
    email: from_addr,
    name: from_name,
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
