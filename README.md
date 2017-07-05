# Interview Knife EC2 / Rails example

## Cookbooks
- The only original cookbook is interview_cookbook
- The only cookbooks that were selected for this project are those in the role's runlist; the other cookbooks are dependencies of these required cookbooks
- Some minor changes were made to 2 community cookbooks: chef_nginx default site code was commented out, and ruby version was supplied for rvm cookbook
- Otherwise all other cookbooks remain unchanged from community versions

The `interview_cookbook` has a few relevant additions besides boilerplate cookbook code:
- `attributes/default.rb`
- `recipes/default.rb`
- `templates/default/nginx_sites_available_puma.erb`
- And of course dependencies named in `metadata.rb`

## Rails App
The Rails App repo used can be found here:
[https://github.com/patrick-armitage/sample_rails_app](https://github.com/patrick-armitage/sample_rails_app)

It's a boilerplate Rails app with custom welcome route/view/controller and some config additions for puma webserver

## Usage

The following knife commands were used to prep server creation:
```shell
knife cookbook upload -a
# since this uploads them alphabetically, in some cases dependencies
# had to be manually uploaded before others
```

Once cookbooks were uploaded, we then create our role with runlist:
```shell
knife role from file interview_role.json
```

Then the server could be created using the code found in `knife_ec2_server_create.sh`:
```shell
knife ec2 server create -r 'role[interview]' -I 'ami-########' -f 't2.micro' -g 'sg-########' -N 'interview-rails' --subnet 'subnet-########' -i ~/.ssh/Interview.pem --ssh-user ubuntu -S 'Interview'
```

## Testing

Once chef completes provisioning the new server, log into AWS console to locate running instance and get the public DNS route.  If everything worked, it should be accessible in a browser via `http://<public_dns_route>`

To see info about nginx proxy server you can run `curl -I http://<public_dns_route>`

If you SSH into the server to look at the Rails process, it is running under the name `puma` and is accessible via `localhost:3000`
