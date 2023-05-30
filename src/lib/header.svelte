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
			  <li><a href="#">Submenu 1</a></li>
			  <li><a href="#">Submenu 2</a></li>
			  <li><a href="#">Submenu 3</a></li>
			</ul>
		  </li>
		  <li class="dropdown">
			<a href="#">Maps &darr;</a>
			<ul class="dropdown-menu">
			  <li><a href="#">Submenu 4</a></li>
			  <li><a href="#">Submenu 5</a></li>
			  <li><a href="#">Submenu 6</a></li>
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
	}

	nav ul li {
		margin-left: 20px;
	}

	nav {
		margin-left: auto;
	}

	nav ul li.dropdown:hover .dropdown-menu {
		display: block;
	}

	.dropdown-menu {
		display: none;
		background: #fff;
		position: absolute;
		padding: 10px;
		z-index: 1;
	}

	.dropdown-menu li {
		margin-bottom: 5px;
	}

	.dropdown-menu li a {
		color: #333;
		text-decoration: none;
	}

</style>
