import { LightningElement,api } from 'lwc';

export default class ChildOne extends LightningElement {
    @api getValueFromParent;
}