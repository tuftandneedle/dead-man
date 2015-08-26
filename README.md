# DeadMan
DeadMan is an implementation of a [dead man's Switch](https://en.wikipedia.org/wiki/Dead_man%27s_switch) to monitor jobs. It's a simple tool that gives visibility  when jobs fail to run.

After a job runs, a heartbeat is sent to DeadMan. If a job is registered to run at a certain interval but doesn't get a heartbeat, it's notification callback will be invoked.

## Install
Put this line in your Gemfile:
    gem 'dead-man', require: 'dead_man'

## Install

## Usage
There are three parts to setting up the Dead Man:
- Registering switches
- Sending heartbeats
- Registering notification callbacks

### Registering Switches
To register a job as a DeadMan switch, simply supply the  unique name of the job along with the frequency at which the job should run:

    DeadMan::Switch.register_switch 'UniqueJobName', 2.hours

### Sending Heartbeats
In your application, send a unique heartbeat to DeadMan for a specified job:

    DeadMan::Heartbeat.pulse('UniqueJobName')

### Registering Callbacks
Now that DeadMan is tracking jobs, the final step is connecting your notification system. Pass a block to register a callback for failure notifications.

    DeadMan::Switch.register_callback -> (message) { SLACK.ping("Failed job: #{message}" }

## Questions & Feedback
Feel free to message me on Github (seanmcoleman) or on twitter (seancoleman86)

## License
Copyright © 2014 Sean Coleman

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
