<script>

    import Header from "../../../lib/Header.svelte";
    import "../../../assets/global.css";

    import RecoveryMaps from "./lib/RecoveryMaps.svelte";

    import mapToronto from "./data/Q_tor.png";
    import mapVancouver from "./data/Q_van.png";
    import mapNewYorkSouth from "./data/Q_nyc_south.png";
    import mapNewYorkNorth from "./data/Q_nyc_north.png";
    import mapSanFrancisco from "./data/Q_sf.png";

    import doomLoopGraphic from "./data/doom-loop-schematic.png";

    import Footnote from '$lib/Footnote.svelte';
	import Footnotes from '$lib/Footnotes.svelte';
	import { createFootnoteStore } from '$lib/footnoteUtils';

	const footnoteStore = createFootnoteStore();
	const { footnotes, addFootnote } = footnoteStore;

	const fns = [
		'In both Canada and the United States, property taxes are the largest contributor to municipal revenues (47 percent average in Canadian municipalities, and 31 percent average across U.S. local governments).',
		'A. Gupta, V. Mittal, and S.V. Nieuwerburgh, <a href="https://papers.ssrn.com/sol3/papers.cfm?abstract_id=4124698" target="_blank">Work From Home and the Office Real Estate Apocalypse</a>, SSRN, 2022; J. Bram, <a href="https://comptroller.nyc.gov/reports/nycs-office-market-doom-loop-or-boom-loop" target="_blank">NYC’s Office Market: Doom Loop or Boom Loop?</a> 2025. <br>Gupta’s et al. 2024 revision found less of a doom loop impact than they originally estimated in their 2022 paper, but still suggested that commercial tax revenue would drop by 47%. Instead, it has increased.',
		'T. Brosy, R. Auxier, N. Airi, G. Garriga, and M. Jha, <a href="https://www.taxpolicycenter.org/publications/future-commercial-real-estate-and-city-budgets" target="_blank">The Future of Commercial Real Estate and City Budgets</a>, The Urban-Brookings Tax Policy Center, May 1, 2024; H. Chernick, H., and A. Reschovsky, <a href="https://www.lincolninst.edu/publications/working-papers/impact-covid-19-pandemic-fiscal-health-american-central-cities/" target="_blank">The Impact of the COVID-19 Pandemic on the Fiscal Health of American Central Cities</a>, 2025, Lincoln Institute of Land Policy Working Paper.',
        'M. Leong, D. Huang, H. Moore, K. Chapple, L. Schmahmann, J. Wang, & N. Allavarpu, <a href="https://www.sciencedirect.com/science/article/abs/pii/S0264275123004006" target="_blank">Can we save the downtown? Examining pandemic recovery trajectories across 62 North American cities</a>, Cities, 143, 2023, ; A. Forouhar, K. Chapple, J. Allen, B. Jeong, & J. Greenberg, <a href="https://journals.sagepub.com/doi/full/10.1177/00420980241270987">Assessing downtown recovery rates and determinants in North American cities after the COVID-19 pandemic</a>, Urban Studies, 62(6), 1209-1231, 2025; A. Forouhar, K. Chapple, R. Pokharel, R., & J. Allen, <a href="https://www.sciencedirect.com/science/article/pii/S0966692325002182" target="_blank">Transit-driven resilience: Unraveling post-COVID-19 urban recovery dynamics</a>, Journal of Transport Geography, 128, 2025.',
        'Chernick & Reschovsky, op. cit.',
        'However, there may be an impact on individual property owners, who will experience increased tax burdens as the rate increases.'
	];


</script>


<Header/>

<main>

    <div class="text">

        <h3>Want to Prevent a Doom Loop? Look at Canada</h3>

        <p><a href="https://schoolofcities.utoronto.ca/people/karen-chapple/">Karen Chapple</a> | December, 2025<br>
        <span style="font-size: 14px; font-style: italic">Graphics by Jeff Allen and Byeonghwa Jeong</span></p><br>

        <p>
            The slow return of office workers to downtowns in the United States and Canada has raised fears of the urban doom loop, a downward spiral in which empty offices and related decline in retail, restaurant, and entertainment expenditures downtown lead to declining rents and land values, decreases in the commercial property tax base, reductions in public services and safety, and an even greater exodus from downtown. The idea of the doom loop stems from 1970s fiscal crises of U.S. cities, such as New York, when the departure of corporate headquarters and middle-class city dwellers strained tax revenues, causing a decline in public services that impacted quality of life and reduced land values, resulting in more flight.
        </p>

        <div style="max-width:600px; width:100%; margin:0 auto;">
            <img
                src="{doomLoopGraphic}"
                alt="Descriptive alt text"
                loading="lazy"
                style="
                display:block;         
                width:100%;          
                max-width:100%;    
                object-fit:contain; 
                image-rendering: -webkit-optimize-contrast; 
                "
            />
        </div>

        <p>
            Researchers have struggled to determine whether cities should expect a post-pandemic doom loop, mostly because of the lack of appropriate data; although office vacancy rates hint at trends, data on office occupancy (and the frequency of remote work) is lacking. Moreover, the fiscal impact of the doom loop depends on how reliant cities are on revenue from property (and in the U.S., also sales) taxes.<Footnote id={addFootnote(fns[0])} /> One prominent example of this uncertainty is New York City, where economists have predicted a doom loop driven by work from home, but the Comptroller’s Office finds a recent “boom loop” of commercial tax revenues that surpass expectations.<Footnote id={addFootnote(fns[1])} /> Other studies have identified a slightly smaller impact on city coffers, generally ranging from 1 to 3 percent.<Footnote id={addFootnote(fns[2])} />
        </p>

        <p>
            Our <a href="https://www.lincolninst.edu/publications/working-papers/assessing-doom-loop-scenarios-four-north-american-downtowns/" target="_blank">recent working paper</a>, published by the Lincoln Institute of Land Policy, overcame many of these research challenges by providing a more accurate assessment of current downtown office building utilization via cell phone data. This then allowed us to develop more realistic scenarios for the future of downtowns. And along the way, we discovered how Canadian cities have protected themselves from ever experiencing a doom loop.
        </p>
        
        <h4>
            Downtown recovery varies
        </h4>

        <p>
            Downtown recovery has varied <a href="https://downtownrecovery.com/blog/toronto-buildings" target="_blank">building by building</a>. Figure 2 illustrates the diverse recovery trajectory (at least in mid-2023) of buildings in four downtowns: New York (both Midtown and the Financial District), San Francisco, Toronto, and Vancouver. The U.S. downtowns house a higher proportion of buildings with lower recovery rates (in red), while in Toronto and Vancouver, more buildings experienced moderate to high recovery rates (in blue). Recovery rates were unevenly distributed within each downtown area, regardless of whether the city was in the U.S. or Canada.
        </p>

        <RecoveryMaps
            title="Downtown San Francisco"
            mapImage={mapSanFrancisco}
        />

        <RecoveryMaps
            title="New York Midtown"
            mapImage={mapNewYorkNorth}
        />

        <RecoveryMaps
            title="New York Financial District"
            mapImage={mapNewYorkSouth}
        />

        <RecoveryMaps
            title="Downtown Toronto"
            mapImage={mapToronto}
        />

        <RecoveryMaps
            title="Downtown Vancouver"
            mapImage={mapVancouver}
        />

        <p>
            Our work at the <a href="https://www.downtownrecovery.com/" target="_blank">Downtown Recovery Project</a> suggests why recovery rates diverge.<Footnote id={addFootnote(fns[3])} /> Economic factors essentially determine downtown activity. The buildings downtown that host a concentration of sectors with remote/hybrid work options – such as information, finance, professional services, and management – display sluggish recovery. Overall, work from home has reduced demand for office space by about 23 percent on average.<Footnote id={addFootnote(fns[4])} /> Conversely, buildings with hotels, restaurants, entertainment, health care, and education exhibit greater resilience post-pandemic. 
        </p>

        <h4>
            Analyzing scenarios for the future of downtown
        </h4>

        <p>
            Looking at trends in office space demand using both real estate and cell phone data, we modeled five scenarios of downtown and assessed value in the future: baseline (business as usual), recovery (return to pre-pandemic activity), modest recovery (more gradual return to pre-pandemic levels), remote (acceleration of remote work trends), and modest remote (more gradual shifts toward remote work). Even under a worst-case scenario of increased remote work and decreased downtown activity, the impact of decreased downtown commercial property tax revenues on city coffers will be minor, and highly unlikely to trigger a doom loop.
        </p>

        <p>
            The full recovery scenario would mean an increase in revenue across cities. Under both baseline and remote scenarios, overall revenue would decrease by one percent or less in New York and Toronto, and from two to four percent in San Francisco. Vancouver would experience greater losses, with a decline of 13 percent to downtown revenues under the remote scenario. However, Vancouver is a special case; though much more dependent on commercial property tax, its tax base is dispersed across multiple subcentres, many of which are recovering faster than downtown. Plus, it benefits from how Canadian municipalities structure their tax revenue streams, as discussed next.
        </p>

        <h4>
            U.S. cities are resilient…but Canada’s are even more so
        </h4>

        <p>
            A four percent decrease in the budget will undoubtedly lead to serious cuts in services in some U.S. cities, but it is unlikely to result in the substantive changes to quality of life that accelerate a doom loop. Moreover, in Canadian cities, tax rates are continually adjusted to ensure revenue neutrality. In other words, the decrease in commercial real estate revenues will be met with an increase in rates on the residential side, essentially erasing the loss. The system thus builds in mitigation for any decline in revenues.<Footnote id={addFootnote(fns[5])} /> 
        </p>
        
        <p>
            This study suffers from a few limitations. Beyond impacts on the commercial property tax base, there could be related impacts on the income tax, the sales tax, user charges, and even intergovernmental aid that impact city budgets as well. We only examined four cities selected primarily for their reliance on sectors that have embraced remote work; however, there are other cities far more vulnerable because of their reliance on the commercial property tax. Future research using this kind of building-level microdata should include these cities as well.
        </p>

        <p>
            The findings of this research should reassure local governments concerned about the likelihood of a doom loop, but this does not mean that problems for downtowns are over. Most downtowns still lack the activity levels they attracted five years ago. Diversifying land use to include more residential buildings, and the economy to include more sectors with essential workers, will make downtowns more resilient to future shocks. Even if the impact of the pandemic on commercial property tax revenue is unlikely to spur a doom loop, it does raise questions about the vulnerability of systems, like in the U.S., that do not adjust rates (as Canada does) to smooth out the impact of real estate downturns. U.S. jurisdictions could benefit from a hard look at the fiscal practices of their neighbour to the north.
        </p>
        
    </div>

    <Footnotes footnotes={footnotes}/>

</main>


<style>

    .mapImg {
        max-width: 600px;
        margin: 0 auto; /* Center the container */
    }
    img {
		border: solid 1px var(--brandDarkBlue);
		min-width: 350px;
		max-width: 100%; /* Set maximum width to 100% of the container */
		height: auto; /* Maintain aspect ratio */
		display: block; /* Remove default image spacing */
		margin: 0 auto; /* Center the image within the container */
	}

    .text {
        border: 0px;
    }


    h4 {
        text-decoration: underline;
    }

    p {
        line-height: 25px;
    }

</style>
