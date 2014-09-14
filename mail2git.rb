require 'liquid'
require 'mail'
require 'rugged'
require 'yaml'

config = YAML.load_file('config.yml')

mail = Mail.read_from_string(STDIN.read)

repo = Rugged::Repository.new(config['git']['repo'])
oid = repo.write(mail.body.to_s, :blob)
index = repo.index
index.read_tree(repo.head.target.tree)
index.add(path: 'test.txt', oid: oid, mode: 0100644)

Rugged::Commit.create(repo, {
  tree: index.write_tree(repo),
  message: mail.subject,
  author: {
    email: mail.from[0],
    name: mail.from[0],
    time: mail.date.to_time
  },
  committer: {
    email: config['git']['commit']['email'],
    name: config['git']['commit']['name'],
    time: Time.now
  },
  parents: [ repo.head.target ].compact,
  update_ref: 'HEAD'
})
