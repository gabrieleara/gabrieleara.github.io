---
pages:
  - Gabriele Ara: /
  - About:        /about
  - Resume:       /curriculum.html
  - Publications: /publications
  - Blog:         /blog
---

# List of Publications

Following is my list of publications, divided into publication types.

!!! note
    For now, the list does not contain details of each publication, just an identifier that will lead you to the actual publication page.

    I apologize for the inconvenience :man_bowing_tone1:.



<div id='publist'>
</div>

<script>
    function generate_publist() {
        const destination = document.getElementById('publist')
        const sections = document.querySelectorAll('li.md-nav__item--section');
        sections.forEach(section => {
            const outer_elem = section.querySelector('label.md-nav__link')
            if (!outer_elem)
                return;

            const label_elem = outer_elem.querySelector('.md-ellipsis');
            if(!label_elem || !label_elem.firstChild)
                return;

            const label = label_elem.firstChild.nodeValue.trim();
            if (label == 'Posts')
                return;

            const section_title = document.createElement('h2')
            section_title.appendChild(document.createTextNode(label));
            destination.appendChild(section_title);

            const elements = section.querySelectorAll('li.md-nav__item');
            elements.forEach(el => {
                const link = el.querySelector('a[href]');
                const link_span = link.querySelector('.md-ellipsis');
                const text = link_span.firstChild.nodeValue.trim()
                const url = link.href.trim()

                const link_node = document.createElement('a');
                link_node.href = url;
                link_node.appendChild(document.createTextNode(text));

                const element_node = document.createElement('p');
                element_node.appendChild(link_node);
                destination.appendChild(element_node);
            });
        });
    }

    generate_publist();
</script>

<style>
</style>
