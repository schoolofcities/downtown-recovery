<script>

	import logo from '../assets/top-logo-full.svg';
	import { onMount } from 'svelte';

	// const baseUrl = '/downtown-recovery';
	// const baseUrl = import.meta.env.BASE_URL;

	// // generated this code for mobile specific rendering - not needed at the moment

	// let isMobile = false;

	// onMount(() => {
	// 	isMobile = window.innerWidth < 600;
	// 	window.addEventListener('resize', handleResize);
	// });

	// function handleResize() {
	// 	isMobile = window.innerWidth < 600;
	// }

</script>



<header>
	<div id="logo">
		<a href="https://www.schoolofcities.utoronto.ca/"><img src={logo} alt="School of Cities"></a>
	</div>
	<p><a href="/">Downtown Recovery</a></p>

	<!-- <img id="line-chart" src='../line-graphic.svg' alt="img" /> -->

</header>

<div id="menu">
	<nav>
		<ul>
		  <li class="dropdown">
			<a href="#">Charts &darr;</a>
			<ul class="dropdown-menu">
			  <li><a href="/charts/rankings">Rankings</a></li>
			  <li><a href="/charts/patterns">Patterns</a></li>
			  <li><a href="/charts/correlations">Correlations</a></li>
			</ul>
		  </li>
		  <li class="dropdown">
			<a href="#">Resources &darr;</a>
			<ul class="dropdown-menu">
			  <li><a href="/death_of_downtown_policy_brief.pdf">Policy Brief</a></li>
			  <li><a href="https://www.youtube.com/watch?v=K2E1uvWqSH8&feature=youtu.be" target="_blank">Explainer Video</a></li>
			  <li><a href="/methodology">Methodology</a></li>
			</ul>
		  </li>
		  <li><a href="/team">Team</a></li>
		</ul>
	</nav> 
</div>



<style>

	header {
		background-color: var(--brandGray90);
		height: 50px; 
		display: flex;
		justify-content: space-between;
		align-items: center;
		border-bottom: solid 1px var(--brandDarkBlue);
	}

	header p {
		color: var(--brandWhite);
		padding-right: 15px;
		text-align: right;
		font-family: TradeGothicBold;
		font-size: 20px;
		line-height: 20px;
	}

	#logo {
		margin: auto 0;
		max-width: 230px;
		height: 70px;
		flex-grow: 1;
		padding-left: 20px;
	}

	a {
		color: white;
		text-decoration: none;
	}

	a:hover {
		opacity: 0.7;
	}

	img {
		height: 50px;
		color: white;
	}

	img:hover {
		height: 50px;
		opacity: 0.7;
		cursor: pointer;
	}

	#line-chart {
		position: absolute;
		top: 10px;
		left: 550px;
	}

	#menu {
		background-color: var(--brandGray90);
		height: 25px; 
		display: flex;
		justify-content: space-between;
		align-items: center;
		border-bottom: solid 1px var(--brandDarkBlue);
	}

	nav {
		margin-left: auto;
	}

	nav ul {
		list-style: none;
		margin: 0;
		padding: 0;
		padding-right: 6px;
		display: flex;
		font-size: 14px;
	}

	nav ul a {
		color: var(--brandWhite);
		text-decoration: none;
		padding-right: 10px;
	}

	nav ul li {
		margin-left: 0px;
		font-size: 14px;
	}

	nav ul li.dropdown:hover .dropdown-menu {
		display: block;
	}

	.dropdown-menu {
		display: none;
		border-left: solid 1px var(--brandDarkBlue);
		border-bottom: solid 1px var(--brandDarkBlue);
		position: absolute;
		padding: 0px;
		margin-top: 0px;
		padding-top: 14px;
		z-index: 20;
	}

	.dropdown-menu li {
		background-color: var(--brandGray90);
		margin-bottom: 2px;
		margin-left: 0px;
		padding-left: 10px;
		padding-top: 4px;
		padding-bottom: 2px;
		border-top: solid 1px var(--brandDarkBlue);
		border-right: solid 1px var(--brandDarkBlue);
	}

	.dropdown-menu li a {
		color: var(--brandWhite);
		text-decoration: none;
	}

</style>
