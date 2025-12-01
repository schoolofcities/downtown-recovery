<script>

    export let footnotes;
    export let footnoteListTitle = "References";

</script>

<div class="footnotes">

    <h2>{footnoteListTitle}</h2>

    {#each footnotes as footnote (footnote.id)}

        <div id={`footnote-${footnote.id}`} class="footnote-item">

            <sup><a href={`#footnote-ref-${footnote.id}`} class="backlink" on:click|preventDefault={() => {
                    const element = document.getElementById(`footnote-ref-${footnote.id}`);
                    const yOffset = -100;
                    if (element) {
                        const y = element.getBoundingClientRect().top + window.pageYOffset + yOffset;
                        window.scrollTo({ top: y, behavior: 'auto' });
                    }
                }}>
                    <b>[{footnote.id}]</b>
                </a> </sup> 

            <p style="display:inline">{@html footnote.text}

            </p>

            <a href={`#footnote-ref-${footnote.id}`} class="backlink" on:click|preventDefault={() => {
                    const element = document.getElementById(`footnote-ref-${footnote.id}`);
                    const yOffset = -100;
                    if (element) {
                        const y = element.getBoundingClientRect().top + window.pageYOffset + yOffset;
                        window.scrollTo({ top: y, behavior: 'auto' });
                    }
                }}>
                    ⮝
                </a>

        </div>

    {/each}

</div>

<style>

    .footnotes {
        max-width: 720px;
        margin: 0 auto;
        position: relative;
        padding-left: 20px;
        padding-right: 20px;
        padding-top: 0px;
        margin-top: 40px;
        margin-bottom: 50px;
        padding-bottom: 20px;
        border: solid 1px var(--brandGray70);
        border-top-right-radius: 50px;
    }

    .footnotes h2 {
        font-size: 22px;
        font-family: TradeGothicBold, sans-serif;
        font-weight: normal;
        margin-bottom: 15px;
        color: var(--brandWhite);
    }
    
    .footnote-item {
        padding-left: 32px;
        margin-bottom: 10px;
        position: relative;
    }

    .footnote-item sup {
        position: absolute;
        font-size: 14px;
        font-family: Roboto, serif;
        font-weight: normal;
        left: 0;
    }

    .footnote-item p {
        font-size: 15px;
        font-family: Roboto, serif;
        font-weight: normal;
        line-height: 24px;
        color: var(--brandWhite);
    }

    .backlink {
        margin-left: 5px;
        font-family: Roboto, serif;
        font-weight: normal;
        text-decoration: none;
        color: var(--brandWhite);
    }

    @media screen and (max-width: 600px) {
        .footnote-item p {
            font-size: 15px;
            line-height: 23px;
        }
    }

    a:hover {
        color: var(--brandLightBlue);
    }
</style>