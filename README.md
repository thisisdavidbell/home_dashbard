# home_dashbard
Dashboard for home status

This page contains Dashing code, plus numerous plugins for dashing, and my own configuration and changes.


NOTES

SCSS
in priority order, starting with the highest priority
 - div referring to super class, which is in assets/stylesheets/<name>.scss
    e.g.: in dashhome.erb <div class="gridster dashhome" >

 - class specified in the div in the erb, which matches class def in <widget>.scss
  e.g.
       homedash.erb:
       <div> .... class="home-header" </div>
       header.scss:
       .home-header {
          background: red;
       }
 - widget type class specified in <widget>.scss as widget-<widgettype> 
  e.g. header.scss
      .widget-header {
          background: red;
       }  
