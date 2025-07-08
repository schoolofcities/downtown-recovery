<script>

	import Header from "../../../lib/Header.svelte";
	import "../../../assets/global.css";

	import mapRecovery from "./assets/resilience_transit-inTO-Conemap.png";
	import chartRecovery from "./assets/resilience_transit-chart.png";

</script>


<Header/>

<main>

	<div class="text">

		<h3>Transit-oriented communities and post-pandemic urban resilience in Toronto</h3>

		<p><i>Research:</i> <a href="https://www.linkedin.com/in/amir-forouhar/" target="_blank">Amir Forouhar</a>, <a href="https://www.linkedin.com/in/ramesh-pokharel/" target="_blank">Ramesh Pokharel</a>, <a href="https://schoolofcities.utoronto.ca/people/karen-chapple/" target="_blank">Karen Chapple</a>, <a href="https://jamaps.github.io/" target="_blank">Jeff Allen</a><br><i>Graphics:</i> Isabeaux Graham, Jeff Allen<br>July, 2025<br><br>
		</p>
		<p>
			The COVID-19 pandemic disrupted urban mobility, work, and social interaction. But how resilient were our neighbourhoods? <a href="https://doi.org/10.1016/j.jtrangeo.2025.104327" target="_blank">Our study, published in the Journal of Transport Geography (2025)</a>, investigates how transit-oriented communities (TOCs) – dense, mixed-use neighbourhoods near frequent public transit – fostered recovery in Toronto. By analyzing mobile phone data and a range of socioeconomic and land-use variables, our research reveals that TOCs exhibit greater resilience compared to non-transit-proximal neighbourhoods.
		</p>

		<h4>Methodology</h4>
		<p>
			Our study employed anonymized and aggregated location data collected from mobile devices, via Cuebiq,  to assess foot traffic in Toronto’s neighbourhoods, comparing areas near subway stations (case neighbourhoods) with matched control areas farther away, using pre-pandemic (March 2019–February 2020) and post-pandemic (March 2022–February 2023) periods to estimate footfall and calculate recovery rates. A regression model with various explanatory variables was employed to assess the impact of transit proximity on recovery while controlling for socioeconomic, industry, and land-use variables.
		</p>
		
		<h4>Key Findings</h4>
		<p>
			Overall, TOCs were more resilient, with case neighbourhoods near subway stations achieving a 116.8% recovery rate (17% above pre-pandemic levels) compared to 104.4% for control areas, a more than 12 percentage-point gap. 
		</p>

	</div>

	<div class="chartImg" style="max-width: 1080px;">

		<span class="img-click">Click on image for higher resolution.</span>
		<a href={mapRecovery} target="_blank"><img src={mapRecovery} alt="Map of Toronto showing difference in pandemic recovery rates of transit station areas compared to similar neighbourhoods" style="max-width: 1080px;"></a>
		
	</div>
	
	<div class="text">

		<p>
			Approximately 65% of case subway stations had higher recovery rates than their control counterparts, with Kipling showing the largest disparity (140.6% vs. 78.7%, a 61.9 percentage-point difference), followed by Finch West, Lawrence, and Sheppard West (53.6–61.4 percentage points), likely due to better connectivity and access to employment, commercial areas, or essential services. However,case neighbourhoods near Pape, Ellesmere, Coxwell, and McCowan had lower recovery rates than controls (-28.2 to -33.8 percentage points), suggesting that transit proximity alone does not guarantee recovery and pointing to the need for supportive socioeconomic conditions, service access, or employment opportunities. 
		</p>

		<p>
			Our regression analysis highlights key drivers of recovery:
		</p>
		<p><span class="highlight">Industry composition:</span> Neighbourhoods with in-person industries (e.g., accommodation/food services, retail, healthcare) experienced stronger recovery, while remote-work-friendly sectors (e.g., professional services, tech, finance) correlated with lower recovery due to reduced foot traffic.</p>
		
		<p><span class="highlight">Socioeconomic factors:</span> Higher immigrant populations and younger residents were linked to faster recovery, driven by contributions to essential sectors and greater mobility. Neighbourhoods with concentrations of older populations recovered more slowly, likely due to health concerns.</p>
		
		<p><span class="highlight">Walkability and commutes:</span> Areas with more residents who walk or use transit to get to work– and where commutes are under 15 minutes– exhibited better recovery, reflecting vibrant, pedestrian-friendly environments.</p>
		
		<p><span class="highlight">Amenity density:</span> Proximity to employment centres, grocery stores, schools, and parks supported robust recovery, highlighting the role of accessible services.</p>

		<h4>Implications for policymakers</h4>
		<p>
			Investing in TOCs strengthens urban resilience by fostering integrated, walkable neighbourhoods with diverse land uses and accessible amenities. Our findings show that TOC resilience stems from a synergy of transit access, mixed-use development, and socioeconomic vitality, rather than transit infrastructure alone. 
		</p>
		<p>
			Policymakers should prioritize walkability, support local businesses, and ensure equitable transit access, while engaging communities to align developments with local needs and mitigate gentrification risks. Monitoring socioeconomic impacts enables adaptive strategies to support resilient urban recovery.
		</p>
		<p>
			For details, see our open-access article in the Journal of Transport Geography (https://doi.org/10.1016/j.jtrangeo.2025.104327).
		</p>


	</div>

	<div class="chartImg">

		<span class="img-click" style="max-width: 720px;">Click on image for higher resolution.</span>
		<a href={chartRecovery} target="_blank"><img src={chartRecovery} style="max-width: 720px;" alt="List transit stations in Toronto showing difference in pandemic recovery rates of transit station areas compared to similar neighbourhoods"></a>
		
	</div>


</main>


<style>

	.chartImg {
		min-height: 300px;
		background-color: none;
		padding-top: 25px;
		padding-bottom: 20px;
		margin: 0 auto; 
		text-align: center;
	}

	img {
		border: solid 1px var(--brandDarkBlue);
		min-width: 350px;
		max-width: 100%; 
		height: auto;
		display: block;
		margin: 0 auto;
	}

	.img-click {
		font-family: Roboto;
		color: rgb(109, 109, 109);
		font-size: 12px;
	}

	.text {
		border: 0px;
	}

	.highlight {
		background-color: var(--brandDarkBlue);
		color: var(--brandYellow);
		padding: 1px;
		font-family: TradeGothicBold;
		font-size: 20px;
	}

	

	p {
		line-height: 25px;
	}

</style>
