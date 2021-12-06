# List of Publications

Following is my list of publications, divided into publication types.

!!! note
    For now, the list does not contain details of each publication, just an identifier that will lead you to the actual publication page.

    I apologize for the inconvenience :man_bowing_tone1:.



<div id='publist'>
</div>

<script>
    var destination = document.getElementById('publist')

    var sections = document.querySelectorAll('li.md-nav__item--section');
    sections.forEach(section => {
        var label = section.querySelector('label.md-nav__link').firstChild.nodeValue.trim();

        var section_title = document.createElement('h2')
        section_title.appendChild(document.createTextNode(label));
        destination.appendChild(section_title);

        var elements = section.querySelectorAll('li.md-nav__item');
        elements.forEach(el => {
            var link = el.querySelector('a[href]');
            var text = link.firstChild.nodeValue.trim()
            var url = link.href.trim()

            var link_node = document.createElement('a');
            link_node.href = url;
            link_node.appendChild(document.createTextNode(text));

            var element_node = document.createElement('p');
            element_node.appendChild(link_node);
            destination.appendChild(element_node);
        });

        // destination.appendChild(section_body);
    });

    // var nav = document.querySelector('.md-nav__item--active > nav:nth-child(3) > ul:nth-child(2)');
    // document.getElementById('nav-destination').appendChild(nav);
    // document.querySelector('div.md-sidebar *').remove();
</script>

<style>
</style>
