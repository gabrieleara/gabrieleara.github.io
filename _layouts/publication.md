---
layout: carded
---

<header>
  <h1>Publication Details</h1>
</header>

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

{% if page.award %}
<style>
  .award {
    position: absolute;
    right: 1rem;
    top: 1rem;
  }
</style>
  <a href='{{ page.award_link }}'>
    <div class="award button" style="display:inline">{{ page.award }}</div>
  </a>
{% endif %}
