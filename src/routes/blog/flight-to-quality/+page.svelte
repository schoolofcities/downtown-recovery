<script>
    import Header from "../../../lib/Header.svelte";
    import "../../../assets/global.css";
    import rentChangesSvg760 from "../../../../src/assets/rent-changes-760px.svg";
    import recoveryRates from "../../../../src/assets/recovery_rates_760px.svg";
</script>

<Header />

<main>
    <div class="text">
        <h3>A “Flight to Quality”? Not So Fast.</h3>

        <p>
            <i>Research:</i>
            <a
                href="https://schoolofcities.utoronto.ca/people/karen-chapple/"
                target="_blank">Karen Chapple</a
            >
            and
            <a
                href="https://schoolofcities.utoronto.ca/people/byeonghwa-jeong/"
                target="_blank">Byeonghwa Jeong</a
            >
            <br /><i>Graphics:</i> Name(s)<br />Month, 2025<br /><br />
        </p>
        <p>
            As the Covid-19 pandemic waned, <a
                href="https://papers.ssrn.com/sol3/papers.cfm?abstract_id=4238253"
                target="_blank">economists began writing</a
            >
            about a “flight to quality,” the phenomenon whereby new commercial office
            buildings with more amenities are able to maintain net effective rents
            even as rents decline on new leases in older buildings. These green,
            energy-efficient buildings typically include not only top-notch facilities
            such as high-tech elevators, 24/7 security, high ceilings, and concierge-level
            services, but also outdoor terraces, cafes, and leisure facilities. In
            some cities, so-called “A+” buildings are seen as the
            <a
                href="https://www.nytimes.com/2023/12/28/nyregion/manhattan-construction-drought-nyc.html?searchResultPosition=2"
                target="_blank">only real hope</a
            > for the office construction sector.
        </p>
        <p>
            At the Downtown Recovery Project, run by researchers at the
            University of Toronto's School of Cities, we began wondering whether
            we could corroborate this flight to quality using footfall data. If
            this “flight” is indeed occurring, we should see consistently more
            activity (as measured by cell phone data) at these A+ buildings than
            in the rest of the commercial office market.
        </p>
        <p>
            So we took a deep dive into activity patterns at the 249 highest
            quality office buildings across the U.S. and Canada in a <a
                href="https://journals.sagepub.com/doi/full/10.1177/23998083251326128"
                target="_blank">new paper</a
            >. We identified A+ buildings using CoStar data, selecting those
            with star ratings of 5. We then compared their activity levels in
            March-June 2023 to the pre-pandemic period, March-June 2019 (i.e.,
            the recovery rate used in our
            <a
                href="https://downtownrecovery.com/charts/rankings"
                target="_blank">rankings</a
            >).
        </p>

        <p>
            What we found surprised us. Even among the highest quality buildings
            in U.S. and Canada, recovery is lagging, and there is great
            diversity in activity levels. Figure 1 shows recovery rates
            throughout the week (left panel) and during working hours only
            (Monday-Friday, 8 AM – 6 PM) (right panel). The mean recovery rate
            among these buildings is 56% overall and 55% during working hours,
            compared to 77% and 78% for all buildings. Recovery rates range from
            15% to over 200%.
        </p>
    </div>

    <div class="chartImg">
        <span class="img-click">Click on image for higher resolution.</span>
        <a class="default" href={recoveryRates} target="_blank"
            ><img src={recoveryRates} alt="" style="max-width: 760px;" /></a
        >
    </div>

    <div class="text">
        <p>
            What accounts for the poor performance of these buildings? Well,
            even if rents are high, some are experiencing high vacancy rates;
            though the mean vacancy rate is just 12%, it ranges up to 68%,
            suggesting that some buildings are emptying out.
        </p>

        <p>
            But might the incidence of work-from-home be impacting performance
            as well? In our <a
                href="https://linkinghub.elsevier.com/retrieve/pii/S0264275123004006"
                target="_blank">research</a
            >, we find that overconcentration in specific economic sectors
            (primarily professional services and information technology) is
            driving low footfall in downtowns. So for this study we next
            analyzed the type of tenants occupying A+ buildings. We classified
            industries based on their potential for remote work and identified
            the occupied square feet by each category. For example, we
            classified professional, scientific, technical services, and
            information technology as remote work; educational services, health
            care, and social assistance as hybrid work; and construction and
            transportation as traditional, in-person work.
        </p>
        <p>
            Indeed, we found that the highest quality office buildings tend to
            have a very high concentration of space housing remote work sectors
            – a mean of 70%. Hybrid and traditional work sectors are
            under-represented in these buildings. This means that most workers
            in those buildings tend to work remotely, which is likely to
            decrease the demand for office space.
        </p>

        <p>
            These findings led us to investigate further the rent dynamics in
            downtown office buildings. Looking at the change in rent per square
            foot (inflation-adjusted) relative to the pre-pandemic period, we
            see declines across the office building sector (Figure 2). Five-star
            buildings have indeed seen occasional upticks, but in general, the
            trajectory is negative. In fact, rents for 5-star offices have
            declined 19% since before the pandemic – more than 4-star or 2-star
            office buildings, or even 2-star retail facilities. These rent
            declines corroborate our findings of poor recovery rates, and
            undermine the concept of a flight to quality.
        </p>

        <div class="chartImg">
            <span class="img-click">Click on image for higher resolution.</span>
            <a class="default" href={rentChangesSvg760} target="_blank"
                ><img
                    src={rentChangesSvg760}
                    alt=""
                    style="max-width: 760px;"
                /></a
            >
        </div>

        <p>
            Thus even if high rent levels in new leases suggest a flight to
            quality, it seems probable that buildings with an overconcentration
            of tenants relying on remote work are not fully utilizing their
            space. With large numbers of employees coming to work only a few
            days a week, and specialization in sectors relying on remote work
            not likely to change, even the highest quality buildings are
            struggling. Many commercial leases will be renegotiated or
            terminated over the next five years – but with inconsistent activity
            levels as described here, even the future of A+ buildings remains
            uncertain.
        </p>
    </div>
</main>

<style>
    .chartImg {
        /* min-height: 300px; */
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
        width: 100%;
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

    /* .highlight {
        background-color: var(--brandDarkBlue);
        color: var(--brandYellow);
        padding: 1px;
        font-family: TradeGothicBold;
        font-size: 20px;
    } */

    p {
        line-height: 25px;
    }

    /* a.default {
        display: inline;
    }
    a.mobile {
        display: none;
    }

    @media (max-width: 515px) {
        a.default {
            display: none;
        }
        a.mobile {
            display: inline;
        }
    } */
</style>
