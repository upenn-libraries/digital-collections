# Penn Libraries Digital Collections

Font-end app for discovery of Penn Libraries Digital Collections content.

## Rubocop

This application uses Rubocop to enforce Ruby and Rails style guidelines. We centralize our UPenn specific configuration in
[upennlib-rubocop](https://gitlab.library.upenn.edu/dld/upennlib-rubocop).


To check style and formatting run:
```ruby
bundle exec rubocop
```

If there are rubocop offenses that you are not able to fix please do not edit the rubocop configuration instead regenerate the `rubocop_todo.yml` using the following command:

```bash
rubocop --auto-gen-config  --auto-gen-only-exclude --exclude-limit 10000
```

To change our default Rubocop config please open an MR in the `upennlib-rubocop` project.
