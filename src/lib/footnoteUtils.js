export function parseMarkdown(text) {
    return text
        .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')       // bold
        .replace(/\*(?!\*)(.+?)\*/g, '<em>$1</em>')              // italics
        .replace(/\[([^\]]+)]\(([^)]+)\)/g, '<a href="$2" target="_blank">$1</a>'); // links
}

export function createFootnoteStore() {
    let footnotes = [];
    
    function addFootnote(text) {
        const id = footnotes.length + 1;
        const parsed = parseMarkdown(text);
        footnotes.push({ id, text: parsed });
        return [id, parsed];
    }
    
    return {
        get footnotes() {
            return footnotes;
        },
        addFootnote
    };
}