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
    <span class="award" style='position: relative; bottom: 0.25em'><i class="icofont-badge icofont-2x" style='position: relative; top:0.15em;'></i>&#32;{{ page.award }}</span>
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


{% if page.youtube %}
<div style="text-align: center; margin: 2em 0 3em">
  <div style="display: inline;">
    {{ page.youtube }}
  </div>
</div>
{%endif%}

{% if page.paper_link %}
{% assign whatisthis = "" %}
{% case page.publication_type %}
    {% when 'conference' %}
      {% assign whatisthis = "paper" %}
    {% when 'journal' %}
      {% assign whatisthis = "paper" %}
    {% when 'bookchapter' %}
      {% assign whatisthis = "book chapter" %}
    {% when 'thesis' %}
      {% assign whatisthis = "thesis" %}
{% endcase %}

<a href='{{ page.paper_link }}'>
    <div class="button" style="display:inline">Download {{ whatisthis }}</div>
</a>
{% endif %}
