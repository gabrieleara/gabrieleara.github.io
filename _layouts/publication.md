---
layout: carded
---

<style>
.pub-header {
  display: flex;
  flex-flow: row wrap;
  justify-content: space-between;
  align-items: flex-start;
  align-content: flex-start;
}

.pub-header[dir=rtl] {
  flex-flow: row-reverse wrap-reverse;
}

.pub-header h1 {
  margin-top: 0 !important;
  margin-right: 1rem;
}

.award-link {
  margin: 0 auto;
  text-align: center;
}

.award-link:hover {
  color: var(--backg) !important;
}

</style>

<header class='pub-header' style='display: flex; justify-content: space-between;'>
  <h1>Publication Details</h1>
{% if page.award %}
  <a class='award-link button' href='{{ page.award_link }}'>
    <div class="award" style="display:inline">{{ page.award }}</div>
  </a>
{% endif %}
</header>

<!--<style>
  .award-container {
    display: block;
    position: relative;
    height: 2em;
  }

  .award:after {
    content:"";
    float:right;
    height: 100%;
    clear:both;
  }

  .award {
    display: inline;
    position: absolute;
    top: -1rem;
    right: 1rem;
  }
</style>
<div class='award-container'>
  
</div>-->


{% include pubdata.html thedata=page %}

{% if page.description %}
<h4>Abstract</h4>
<p style="position:relative; top:-1em;">
  {{ page.description }}
</p>
{% endif %}

{% if page.paper_link %}
<a href='{{ page.paper_link }}'>
    <div class="button" style="display:inline">Download paper</div>
</a>
{% endif %}
