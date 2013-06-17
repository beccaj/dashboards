## Description

[Dashing](http://shopify.github.com/dashing) widget to display a [Jenkins](http://jenkins-ci.org/) build status and build progress

The widget is based on the meter-widget which is default in the Dashing installation

The widget can also see the progress of a "pre-build", i.e if you have a job triggering the actual build you want to define, you can configure this job in the jenkins_build.rb as a prebuild. 

For more information, please see [Coding Like a tosser](http://wp.me/p36836-p)

##Usage
The files `jenkins_build.coffee`, `jenkins_build.html` and `jenkins_build.scss` goes in the `/widget/jenkins_build` directory.

The `jenkins_build.rb` goes in the `/jobs` directory

Put the following in your dashingboard.erb file to show the status:
  
    <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="JOB" data-view="JenkinsBuild" data-title="BUILD" data-min="0" data-max="100"></div>
    </li>

##Settings (`jenkins_build.rb`)
Change the `JENKINS_URI` to your correct uri for Jenkins
Put all the jobnames and pre job names in the `job_mapping` 