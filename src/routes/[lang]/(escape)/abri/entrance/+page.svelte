<ModalComponent
        parentDoneAction={() => hideScenario = false}>
    <Grid>
        <Row>
            <Column>
                <ImageLoader
                        src="{base}/abri/entrance/enter.jpg" alt={$t('shelterEntrance.before.image')} fadeIn={true}/>
            </Column>
            <Column>
                <p>{$t('shelterEntrance.before.row.1')}</p>
                <p>{$t('shelterEntrance.before.row.2')}</p>
            </Column>
        </Row>
    </Grid>
</ModalComponent>
<br aria-hidden="true"/>
<TypewriterComponent disabled={hideScenario} delay={3000} parentDoneAction={() => {hideGoal = false}}>
    <h2><u><i>{$t('common.layout.title.scenario')}</i></u></h2>
    <p>{$t('shelterEntrance.scenario.row.1')}</p>
    <p>{$t('shelterEntrance.scenario.row.2')}</p>
    <p style="font-style: italic;">{$t('shelterEntrance.scenario.row.3')}</p>
    <p>{$t('shelterEntrance.scenario.row.4')}</p>
</TypewriterComponent>
<br aria-hidden="true"/>
<TypewriterComponent disabled={hideGoal} parentDoneAction={() => showButtons = true}>
    <h2><u><i>{$t('common.layout.title.goal')}</i></u></h2>
    <p>{$t('shelterEntrance.goal.row.1')}</p>
</TypewriterComponent>
{#if showButtons}
    <div style="display: flex; margin-top: 2rem; align-items: center; justify-content: space-between;">
        <Slider
                labelText={$t('shelterEntrance.test.contrast')}
                min={0}
                max={100}
                maxLabel="100"
                value={contrast}
                step={1}
                style="align-items: normal; margin-right: 2em"
                aria-hidden={accessibilityMode}
                disabled={accessibilityMode}
                on:input={(value) => {{contrast = value.detail}}}
        />
        <Column sm style="display: flex; flex-direction: column; text-align: center;">
            <span>{firstButtonLabel}</span>
            <Button
                    style="background-color:#0E160F; filter: contrast({contrast}%) brightness({brightness}%);"
                    class="coloredButton"
                    aria-label={$t('shelterEntrance.test.buttons.green')}
                    on:click={() => validOrder(0)} aria-pressed={isButtonPressed(firstButtonLabel)}></Button>
        </Column>
        <Column sm style="display: flex; flex-direction: column; text-align: center;">
            <span>{secondButtonLabel}</span>
            <Button
                    style="background-color:#16110E; filter: contrast({contrast}%) brightness({brightness}%);"
                    class="coloredButton"
                    aria-label={$t('shelterEntrance.test.buttons.orange')}
                    on:click={() => validOrder(1)} aria-pressed={isButtonPressed(secondButtonLabel)}>
            </Button>
        </Column>
        <Column sm style="display: flex; flex-direction: column; text-align: center;">
            <span>{thirdButtonLabel}</span>
            <Button
                    style="background-color:#161113; filter: contrast({contrast}%) brightness({brightness}%);"
                    class="coloredButton"
                    aria-label={$t('shelterEntrance.test.buttons.rose')}
                    on:click={() => validOrder(2)} aria-pressed={isButtonPressed(thirdButtonLabel)}>
            </Button>
        </Column>
        <Column sm style="display: flex; flex-direction: column; text-align: center;">
            <span>{fourthButtonLabel}</span>
            <Button
                    style="background-color:#16150E; filter: contrast({contrast}%) brightness({brightness}%);"
                    class="coloredButton"
                    aria-label={$t('shelterEntrance.test.buttons.yellow')}
                    on:click={() => validOrder(3)} aria-pressed={isButtonPressed(fourthButtonLabel)}>
            </Button>
        </Column>
        <Slider
                labelText={$t('shelterEntrance.test.brightness')}
                min={0}
                max={100}
                maxLabel="100"
                value={brightness}
                step={1}
                aria-hidden={accessibilityMode}
                disabled={accessibilityMode}
                style="align-items: normal; margin-left: 2rem"
                on:input={(value) => {{brightness = value.detail}}}
        />
    </div>
    {#if isWaiting}
        <LoadingComponent/>
    {/if}
{/if}
{#if showError}
    <ToastNotification
            lowContrast
            fullWidth
            kind="error"
            title={$t('shelterEntrance.test.error.title')}
            subtitle={$t('shelterEntrance.test.error.message')}
            caption={$t('shelterEntrance.test.error.caption')}
            {timeout}
            on:close={(e) => {
                showError = false;
                firstButtonLabel = " "
                secondButtonLabel = " "
                thirdButtonLabel = " "
                fourthButtonLabel = " "
              }}
    />
{/if}
<script lang="ts">
    import "carbon-components-svelte/css/g90.css";
    import {Button, Column, Grid, ImageLoader, Row, Slider, ToastNotification} from "carbon-components-svelte";
    import {base} from '$app/paths';
    import TypewriterComponent from "$lib/technicalComponent/TypewriterComponent.svelte";
    import ModalComponent from "$lib/technicalComponent/ModalComponent.svelte";
    import LoadingComponent from "$lib/technicalComponent/LoadingComponent.svelte";
    import {redirect, Step, t} from "$lib";
    import {onMount} from "svelte";
    import {RenderData, renderStore} from "$lib/store/inMemoryStore/RenderStore";
    import {changeSource} from "$lib/store/inMemoryStore/AudioStore";
    import {getAccessibilityMode, getAccessibilityModeStore} from "$lib/store/AccessibilityModeStore";
    import {page} from "$app/stores";

    export let accessibilityMode = false

    onMount(() => {
        changeSource("/ost/step1.mp3")
        accessibilityMode = getAccessibilityMode()
        getAccessibilityModeStore()?.subscribe((data) => {
            accessibilityMode = data === "true"
        })
        renderStore.set(new RenderData($t('common.step.shelterEntrance'), $t('shelterEntrance.neon.title'), $t('shelterEntrance.neon.subtitle'), Step.ABRI_ENTRANCE));
    })

    const goodOrder = [3, 2, 0, 1];
    let orderTyped: number[] = [];
    let showError = false;
    let hideScenario = true;
    let hideGoal = true;
    let showButtons = false;
    let isWaiting = false;
    let contrast = 0;
    let brightness = 0;
    let firstButtonLabel = " "
    let secondButtonLabel = " "
    let thirdButtonLabel = " "
    let fourthButtonLabel = " "

    const timeout: number = 4000;
    const validOrder = (id: number) => {
        if (!orderTyped.includes(id)) orderTyped.push(id)
        if (id === 0 && !isButtonPressed(firstButtonLabel)) firstButtonLabel = displayOrder(id)
        if (id === 1 && !isButtonPressed(secondButtonLabel)) secondButtonLabel = displayOrder(id)
        if (id === 2 && !isButtonPressed(thirdButtonLabel)) thirdButtonLabel = displayOrder(id)
        if (id === 3 && !isButtonPressed(fourthButtonLabel)) fourthButtonLabel = displayOrder(id)
        if (orderTyped.length >= 4) {
            if (JSON.stringify(orderTyped) == JSON.stringify(goodOrder)) {
                isWaiting = true;
                redirect($page.params.lang, "abri/computer")
            } else {
                showError = true;
                orderTyped = [];
            }
        }
    }

    function displayOrder(id: number) {
        let number = orderTyped.indexOf(id)
        let position = number + 1
        return position > 0 ? position.toString() : ""
    }

    function isButtonPressed(button: string) {
        return button !== " "
    }

</script>
<style lang="css">
    @import url(/css/app.css);
    @import url(/css/neon.css);
</style>
