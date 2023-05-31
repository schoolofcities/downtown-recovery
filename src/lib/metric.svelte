<script>
    import Select from "../lib/Select.svelte";
    let selected;
</script>
    
    <Select options={[{"text":"aaa"},{"text":"bbb"},{"text":"ccc"}]}
                    bind:value={selected}/>
    {JSON.stringify(selected, null, 2)}
    {(console.log(selected),'')}