<script>

	import logo from '../assets/top-logo-full.svg';

</script>

<header>

	<div id="logo">
		<a href="https://www.schoolofcities.utoronto.ca/"><img src={logo} alt="School of Cities"></a>
	</div>

	<nav>
		<ul>
		  
		  <li class="dropdown">
			<a href="#">Charts &darr;</a>
			<ul class="dropdown-menu">
			  <li><a href="#">Rankings</a></li>
			  <li><a href="#">Rankings (Europe Suppliment)</a></li>
			  <li><a href="#">Patterns</a></li>
			  <li><a href="#">Explanatory Variables</a></li>
			</ul>
		  </li>
		  <li class="dropdown">
			<a href="#">Maps &darr;</a>
			<ul class="dropdown-menu">
			  <li><a href="#">Submenu 4</a></li>
			  <li><a href="#">Submenu 5</a></li>
			</ul>
		  </li>
		  <li><a href="#">Methodology</a></li>
		  <li><a href="#">Team</a></li>
		</ul>
	  </nav>

</header>

<style>

	header {
		background: var(--brandDarkGray);
		height: 50px; 
		display: flex;
		justify-content: space-between;
		align-items: center;
		border-bottom: solid 1px var(--brandDarkBlue);
	}

	#logo {
		margin: auto 0;
		max-width: 230px;
		height: 70px;
		flex-grow: 1;
		padding-left: 20px;
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

	nav ul {
		list-style: none;
		margin: 0;
		padding: 0;
		padding-right: 20px;
		display: flex;
	}

	nav ul a {
		color: var(--brandWhite);
		text-decoration: none;
		padding-right: 10px;
	}

	nav ul li {
		margin-left: 0px;
	}

	nav {
		margin-left: auto;
	}

	nav ul li.dropdown:hover .dropdown-menu {
		display: block;
	}

	.dropdown-menu {
		display: none;
		background-color: var(--brandGray90);
		border-left: solid 1px var(--brandDarkBlue);
		border-bottom: solid 1px var(--brandDarkBlue);
		position: absolute;
		padding: 0px;
		margin-top: 0px;
		padding-top: 14px;
		z-index: 20;
	}

	.dropdown-menu li {
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
