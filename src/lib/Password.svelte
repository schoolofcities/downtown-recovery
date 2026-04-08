<script>
	
	let password = '';
	let isAuthenticated = false;
	const correctPassword = 'meowcat'; 

	function checkPassword() {
		if (password === correctPassword) {
		isAuthenticated = true;
		} else {
		alert('Incorrect password');
		}
	}

</script>

{#if !isAuthenticated}
	<div class="overlay">
		<div class="password-box">
			<h3>This page is under development :) Please do not share without permission.</h3><br>
		<input
			type="password"
			bind:value={password}
			placeholder="Enter password"
			on:keydown={(e) => e.key === 'Enter' && checkPassword()}
		/>
		
		<button on:click={checkPassword}>Unlock </button>
		</div>
	</div>
{/if}

<style>

	.overlay {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background-color: rgba(255, 255, 255, 0.9);
		backdrop-filter: blur(4px);
		z-index: 9999;
		display: flex;
		justify-content: center;
		align-items: center;
	}

	.password-box {
		background: white;
		padding: 2rem;
		border-radius: 8px;
		box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
		text-align: center;
	}

	input {
		padding: 0.5rem;
		margin-right: 0.5rem;
		border: 1px solid #ccc;
		border-radius: 4px;
	}

	button {
		padding: 0.5rem 1rem;
		background-color: var(--brandDarkBlue);
		color: white;
		border: none;
		border-radius: 4px;
		cursor: pointer;
	}

	button:hover {
		background-color: var(--brandLightBlue);
	}

	h3 {
		font-family: TradeGothicBold;
		font-weight: normal;
		font-size: 20px;
		color: var(--brandDarkBlue);
	}

</style>
