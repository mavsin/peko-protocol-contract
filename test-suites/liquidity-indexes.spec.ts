import { expect } from 'chai';
import { BigNumber } from '@ethersproject/bignumber';
import { makeSuite, TestEnv } from './helpers/make-suite';
import { evmSnapshot, evmRevert } from '@aave/deploy-v3';
import './helpers/utils/wadraymath';

makeSuite('Pool: liquidity indexes misc tests', (testEnv: TestEnv) => {
  let snap: string;

  beforeEach(async () => {
    snap = await evmSnapshot();
  });

  afterEach(async () => {
    await evmRevert(snap);
  });

  it('Validates that the flash loan fee properly takes into account both aToken supply and accruedToTreasury', async () => {
    const {
      helpersContract,
      weth,
      aWETH,
      users: [depositorWeth],
    } = testEnv;

    /**
     * 1. Flashes 0.8 WETH
     * 2. Flashes again 0.8 ETH (to have accruedToTreasury)
     * 3. Validates that liquidity index took into account both aToken supply and accruedToTreasury
     */

    const wethReserveDataAfterSecondFlash = await helpersContract.getReserveData(weth.address);

    const totalScaledWithTreasuryAfterSecondFlash = (
      await aWETH.scaledBalanceOf(depositorWeth.address)
    ).add(wethReserveDataAfterSecondFlash.accruedToTreasuryScaled.toString());

    expect(await weth.balanceOf(aWETH.address)).to.be.closeTo(
      BigNumber.from(totalScaledWithTreasuryAfterSecondFlash.toString()).rayMul(
        wethReserveDataAfterSecondFlash.liquidityIndex
      ),
      1,
      'Scaled total supply not (+/- 1) equal to WETH balance of aWETH'
    );
  });
});
